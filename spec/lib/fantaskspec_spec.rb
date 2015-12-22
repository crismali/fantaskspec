require "spec_helper"

RSpec.describe Fantaskspec do

  context "matchers", type: :rake do
    context "dependent_task" do
      describe "#depends_on" do
        it "passes if the task depends on the specified task" do
          expect(subject).to depend_on("some_task")
        end

        it "is indifferent to symbols" do
          expect(subject).to depend_on(:some_task)
        end

        it "fails if the task does not depend on the specified task" do
          expect do
            expect(subject).to depend_on("foo")
          end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
        end

        context "multi_dependent" do
          it "passes if the task depends on all of the specified tasks" do
            expect(subject).to depend_on("namespaced:namespaced", "some_task")
          end

          it "fails if the task does not depend on one of the specified tasks" do
            expect do
              expect(subject).to depend_on("dependent_task", "some_task")
            end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
          end

          it "fails if the task does not depend on the specified tasks in the same order" do
            expect do
              expect(subject).to depend_on("some_task", "namespaced:namespaced")
            end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
          end

          it "fails if the task depends on other tasks that are not specified" do
            expect do
              expect(subject).to depend_on("some_task")
            end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
          end
        end
      end
    end
  end

  describe "#initialize_configuration" do
    let(:config) { RSpec::Core::Configuration.new }

    it "mixes in the rspec rake example group into the rake type" do
      subject.initialize_configuration(config)

      if RSpec::Version::STRING.to_f >= 3.2
        expected = [Fantaskspec::RakeExampleGroup, { type: :rake }]
        suspect = config.instance_eval { @include_modules }.items_and_filters
      else
        expected = [:include, Fantaskspec::RakeExampleGroup, { type: :rake }]
        suspect = config.include_or_extend_modules
      end

      expect(suspect).to include(expected)
    end

    it "defines #infer_rake_task_specs_from_file_location! on the configuration object" do
      subject.initialize_configuration(config)
      expect(config).to respond_to(:infer_rake_task_specs_from_file_location!)
    end
  end

  context "rake type specs", type: :rake do
    it "has access to methods defined in the rake example group" do
      expect(self).to be_a(Fantaskspec::RakeExampleGroup)
    end

    context "task inference" do
      it "raises an error if it cannot infer the task name" do
        expect { task_name }.to raise_error(Fantaskspec::AmbiguousNameError, "unable to infer the name of the task. Please rename your describe/context or specify your task name via `let(:task_name) { ... }`")
      end

      context "some_task" do
        it "makes some_task the subject" do
          expect(subject.name).to eq("some_task")
        end

        it "makes `task` the task" do
          expect(task.name).to eq("some_task")
        end

        [
          "this context has spaces but",
          "ThisContextLacksSpacesButHasCapitalLettersBut",
          "this:context:looks:like:a:rake:task:but"
        ].each do |context_name|
          context context_name do
            [:subject, :task].each do |type|
              it "still has some_task as the #{type}" do
                expect(send(type).name).to eq("some_task")
              end
            end
          end
        end

        context "this will have another rake task named context" do
          context "dependent_task" do
            it "makes dependent_task the subject" do
              expect(subject.name).to eq("dependent_task")
            end

            it "makes `task` the task" do
              expect(task.name).to eq("dependent_task")
            end
          end
        end
      end

      context "namespaced:namespaced" do
        it "makes namespaced:namespaced the subject" do
          expect(subject.name).to eq("namespaced:namespaced")
        end
      end
    end
  end
end
