require "rspec/helper"
describe "sprockets on Jekyll" do
  let(:env) { Jekyll::Assets::Env.new(stub_jekyll_site) }
  it "makes sure that sprockets is on the Jekyll instance" do
    expect(env.jekyll.sprockets).to be_kind_of Jekyll::Assets::Env
  end
end
