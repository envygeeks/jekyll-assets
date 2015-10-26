require "rspec/helper"
describe "sprockets helpers" do
  let(:env) { Jekyll::Assets::Env.new(stub_jekyll_site) }
  it "initializes the helpers" do
    Sprockets::Helpers.instance_methods.each do |method|
      expect(env.context_class.method_defined?(method)).to be_truthy
    end
  end

  it "uses our digest" do
    expect(Sprockets::Helpers.digest).to eq env.digest?
  end

  it "adds our prefix" do
    expect(Sprockets::Helpers.prefix).to eq env.prefix
  end
end
