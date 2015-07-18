require "rspec/helper"
describe Jekyll::Assets::Helpers::JavaScript do
  it "works" do
    expect(described_class.has_javascript? { true }).to eq(
      true
    )
  end

  it "logs when it cannot load a JavaScript runtime" do
    expect(Jekyll.logger).to receive(:debug).with(any_args)
    described_class.has_javascript? do
      raise ExecJS::RuntimeUnavailable
    end
  end
end
