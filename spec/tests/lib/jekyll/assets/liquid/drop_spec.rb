# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
require "nokogiri"

describe Jekyll::Assets::Liquid::Drop do
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

    @site.process
  end

  #

  def render(data)
    payload = @site.site_payload.merge("assets" => @env.to_liquid_payload)
    @renderer.file(__FILE__).parse(data).render!(
      payload, @register
    )
  end

  #

  def fragment(html)
    Nokogiri::HTML.fragment(html).children.first
  end

  #

  it "allows you to get the content type" do
    expect(render("{{ assets['ruby.png'].content_type }}")).to eq(
      "image/png"
    )
  end

  #

  it "allows the user to pull out an asset" do
    expect(render("{{ assets['bundle.css'] }}")).to eq(
      "Jekyll::Assets::Liquid::Drop"
    )
  end

  #

  context "with an image" do
    it "allows the user to get the width" do
      expect(render("{{ assets['ruby.png'].width }}")).to eq(
        "62"
      )
    end

    #

    it "allows the user to get the height" do
      expect(render("{{ assets['ruby.png'].height }}")).to eq(
        "62"
      )
    end
  end
end
