# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8

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

  def rdim(val)
    return [
      val - 2, val + 2
    ]
  end

  #

  def dimensions(asset)
    return FastImage.new(asset).size
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

  it "allows the user to enable manual retina sizes" do
    stub_asset_config "features" => {
      "automatic_img_size" => "2"
    }

    ogw = dimensions(@env.find_asset("ruby.png").pathname).first
    ogh = dimensions(@env.find_asset("ruby.png").pathname). last
    ngw = stub_tag("img", "ruby.png").attr( :width).to_i
    ngh = stub_tag("img", "ruby.png").attr(:height).to_i

    expect(ngw).to be_between(*rdim(ogw / 2))
    expect(ngh).to be_between(*rdim(ogh / 2))
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
