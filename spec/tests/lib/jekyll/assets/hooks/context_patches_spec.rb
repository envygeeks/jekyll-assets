# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
describe "context hook" do
  let :env do
    Jekyll::Assets::Env.new(
      stub_jekyll_site
    )
  end

  #

  it "patches asset context so we can track used assets in assets" do
    expect(env.context_class.method_defined?(:_old_asset_path)).to(
      be true
    )
  end

  #

  context "#context_class#_asset_path" do
    it "adds the asset to the env#used set" do
      env.find_asset "context", :accept => "text/css"
      expect(env.used.first.pathname.fnmatch?("*/context.jpg")).to eq true
      expect(env.used.size).to eq 1
    end

    #

    it "should write the asset when write_all is done" do
      env.find_asset "context", :accept => "text/css"; env.write_all
      expect(Pathname.new(env.jekyll.in_dest_dir).join("assets/context.jpg")).to(
        exist
      )
    end
  end
end
