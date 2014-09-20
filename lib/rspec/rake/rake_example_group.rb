module RSpec
  module Rake
    class AmbiguousNameError < StandardError
    end

    module RakeExampleGroup
      def self.included(klass)
        klass.instance_eval do
          let(:task_names) { ::Rake::Task.tasks.map(&:name) }
          let(:task_name) do
            descriptions = self.class.parent_groups.map(&:description)

            name = descriptions.find do |description|
              task_names.include?(description)
            end

            if name.nil?
              raise AmbiguousNameError, "unable to infer the name of the task. Please rename  your describe/context or specify your task name by 'letting' :task_name"
            end

            name
          end

          subject { ::Rake::Task[task_name] }
        end
      end
    end
  end
end
