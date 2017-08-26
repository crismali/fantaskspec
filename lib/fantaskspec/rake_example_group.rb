module Fantaskspec
  class AmbiguousNameError < StandardError
  end

  module RakeExampleGroup
    extend RSpec::Matchers::DSL

    def self.included(klass)
      klass.instance_eval do
        let(:task_names) { ::Rake::Task.tasks.map(&:name) }
        let(:task_name) do
          descriptions = self.class.parent_groups.map(&:description)

          name = descriptions.find do |description|
            task_names.include?(description)
          end

          if name.nil?
            raise AmbiguousNameError, "unable to infer the name of the task. Please rename your describe/context or specify your task name via `let(:task_name) { ... }`"
          end

          name
        end

        let(:task) { ::Rake::Task[task_name] }
        subject { task }

        include(Module.new do
                  def to_task_arguments(*task_args)
                    Rake::TaskArguments.new(task.arg_names, task_args)
                  end
                end)
      end
    end

    matcher :depend_on do |*expected|
      match do |actual|
        actual.prerequisites == expected.map(&:to_s)
      end
    end

    matcher :depend_on_subset do |*expected|
      match do |actual|
        (actual.prerequisites & expected.map(&:to_s)) == expected.map(&:to_s)
      end
    end
  end
end
