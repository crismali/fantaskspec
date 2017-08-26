require "rake"
require "rspec/core"

require "fantaskspec/version"
require "fantaskspec/rake_example_group"

module Fantaskspec
  TASK_SPEC_PATHS = [%r{spec/tasks}, %r{spec/lib/tasks}].freeze

  def self.initialize_configuration(config)
    config.include RakeExampleGroup, type: :rake

    def config.infer_rake_task_specs_from_file_location!
      TASK_SPEC_PATHS.each do |escaped_path|
        define_derived_metadata(file_path: escaped_path) do |metadata|
          metadata[:type] ||= :rake
        end
      end
    end
  end

  initialize_configuration RSpec.configuration
end
