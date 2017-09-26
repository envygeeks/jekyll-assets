# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "ImageOptim AssetPath Proxy" do
  before :all do
    @site = stub_jekyll_site("assets" => { "image_optim" => {
      "default" => {}
    }})
    @env = Jekyll::Assets::Env.new(@site)
    @asset = @env.find_asset(
      "ubuntu.png"
    )
  end

  #

  def stub_tag(*args)
    context = Jekyll::Assets::Liquid::ParseContext.new
    Jekyll::Assets::Liquid::Tag.send(:new, "asset_path", "ubuntu.png #{args.join(" ")}", context).render(
      OpenStruct.new(:registers => {
        :site => @site
      })
    )
  end

  #

  def get_asset(asset_path)
    Pathutil.new(@env.in_cache_dir(asset_path.gsub(
      /^#{Regexp.escape(@env.asset_config["prefix"])}\//, ""
    )))
  end

  #

  it "allows a user to compress image using 'default' configuration" do
    asset = get_asset(stub_tag("image_optim:default"))
    expect(Pathutil.new(@asset.filename).size).to(
      be > asset.size
    )
  end

end
