require "rspec/core"

require "rspec/rake/version"
require "rspec/rake/rake_example_group"

module RSpec
  module Rake
    def self.initialize_configuration(config)
      config.include RakeExampleGroup, type: :rake
    end

    initialize_configuration RSpec.configuration
  end
end
