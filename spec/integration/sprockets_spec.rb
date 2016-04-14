# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
describe "SPROCKETS INTEGRATION" do
  let :env do
    Jekyll::Assets::Env.new(site)
  end

  #

  let :path do
    site.in_dest_dir(
      "/assets"
    )
  end

  #

  let :site do
    stub_jekyll_site
  end

  #

  before :each, :process => true do
    site.process
  end

  #

  before :all do
    @site = stub_jekyll_site
    @env  = Jekyll::Assets::Env.new(
      @site
    )
  end

  #

  it "allows you to merge CSS with sprockets.", :process => true do
    matcher = /^body {\n\s+background-image: "\/assets\/context.jpg";\s+\}/m
    expect(@env.find_asset("merge").to_s).to match(
      matcher
    )
  end
end
