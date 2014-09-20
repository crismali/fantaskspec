require "spec_helper"

RSpec.describe RSpec::Rake do
  describe "#initialize_configuration" do
    let(:config) { RSpec::Core::Configuration.new }

    it "mixes in the rspec rake example group into the rake type" do
      expected = [:include, RSpec::Rake::RakeExampleGroup, { type: :rake }]
      subject.initialize_configuration(config)
      expect(config.include_or_extend_modules).to include(expected)
    end
  end

  context "rake type specs", type: :rake do
    it "has access to methods defined in the rake example group" do
      expect(self).to be_a(RSpec::Rake::RakeExampleGroup)
    end
  end
end
