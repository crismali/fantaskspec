require "spec_helper"

RSpec.describe RSpec::Rake do
  describe "#initialize_configuration" do
    let(:config) { RSpec::Core::Configuration.new }

    it "mixes in the rspec rake example group into the rake type" do
      expected = [:include, RSpec::Rake::RakeExampleGroup, { type: :rake }]
      subject.initialize_configuration(config)
      expect(config.include_or_extend_modules).to include(expected)
    end

    it "defines #infer_rake_task_specs_from_file_location! on the configuration object" do
      subject.initialize_configuration(config)
      expect(config).to respond_to(:infer_rake_task_specs_from_file_location!)
    end
  end

  context "rake type specs", type: :rake do
    it "has access to methods defined in the rake example group" do
      expect(self).to be_a(RSpec::Rake::RakeExampleGroup)
    end

    context "task inference" do
      it "raises an error if it cannot infer the task name" do
        expect { task_name }.to raise_error(RSpec::Rake::AmbiguousNameError, "unable to infer the name of the task. Please rename  your describe/context or specify your task name by 'letting' :task_name")
      end

      context "some_task" do
        it "makes some_task the subject" do
          expect(subject.name).to eq("some_task")
        end

        context "this context has spaces so" do
          it "still has some_task as the subject" do
            expect(subject.name).to eq("some_task")
          end
        end

        context "ThisContextLacksSpacesButHasCapitalLetters" do
          it "still has some_task as the subject" do
            expect(subject.name).to eq("some_task")
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
