require "rspec/helper"

describe "compass sass/scss" do
  let(:env) { Jekyll::Assets::Env.new(stub_jekyll_site) }
  it "makes sure it's available in the path" do
    expect(env.paths.grep(/compass-core-.*\/stylesheets\Z/).any?).to be_truthy
  end

  it "allows you to use it" do
    expect(env.find_asset("compas").to_s).to eq \
      ".hello {\n  background: \"#fff\"; }\n"
  end
end
