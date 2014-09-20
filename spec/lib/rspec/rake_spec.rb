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
  end
end
