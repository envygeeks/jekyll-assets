require "rspec/helper"
describe "configuration" do
  let(:env) { Jekyll::Assets::Env.new(stub_jekyll_site) }
  it "adds the configuration onto env" do
    expect(env.config).not_to be_empty
  end
end
