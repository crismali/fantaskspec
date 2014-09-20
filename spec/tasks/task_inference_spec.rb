require "spec_helper"

RSpec.describe "config#infer_rake_task_specs_from_file_location!" do
  it "makes specs in spec/tasks have a type of rake" do |example|
    expect(example.metadata[:type]).to eq(:rake)
  end

  context "prefined type", type: :foo do
    it "does not override" do |example|
      expect(example.metadata[:type]).to eq(:foo)
    end
  end
end
