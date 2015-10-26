require "rspec/helper"

describe "context hook" do
  let(:env) { Jekyll::Assets::Env.new(stub_jekyll_site) }
  it "patches asset context so we can track used assets in assets" do
    expect(env.context_class.method_defined?(:_old_asset_path)).to be true
  end

  context "#context_class#_asset_path" do
    it "adds the asset to the env#used set" do
      env.find_asset "context", :accept => "text/css"
      expect(env.used.size).to eq 1
      expect(env.used.first.pathname.fnmatch?("*/context.jpg")).to eq \
        true
    end
  end
end
