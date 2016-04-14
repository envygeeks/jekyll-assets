# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
require "nokogiri"

describe Jekyll::Assets::Liquid::Tag::Defaults::Image do
  subject do
    described_class
  end

  #

  before :all do
    @site = stub_jekyll_site
    @env = Jekyll::Assets::Env.new(@site)
    @renderer = @site.liquid_renderer
    @register = {
      :registers => {
        :site => @site
      }
    }
  end

  #

  def stub_tag(tag, data)
    payload = format("{%% %s %s %%}", tag, data)
    fragment(@renderer.file(__FILE__).parse(payload).render!(
      @site.site_payload, @register
    ))
  end

  #

  def fragment(html)
    Nokogiri::HTML.fragment(html).children.first
  end

  #

  it "adds a default alt attribute to img" do
    expect(stub_tag("img", "ruby.png").attr("alt")).to eq(
      "ruby.png"
    )
  end

  #

  it "sets a default width" do
    expect(stub_tag("img", "ruby.png").attr("width")).to(
      match(/\A\d+\Z/)
    )
  end

  #

  it "sets a default height" do
    expect(stub_tag("img", "ruby.png").attr("height")).to(
      match(/\A\d+\Z/)
    )
  end

  #

  it "allows the user to disable width and height" do
    stub_asset_config "features" => {
      "automatic_img_size" => false
    }

    result = stub_tag("img", "ruby.png")
    expect(result.attr("width")).to be_nil
    expect(result.attr("height")).to be_nil
  end

  #

  it "allows the user to disable alt" do
    stub_asset_config "features" => {
      "automatic_img_alt" => false
    }

    result = stub_tag("img", "ruby.png")
    expect(result.attr("alt")).to be_nil
  end
end
