# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
require "nokogiri"

describe Jekyll::Assets::Liquid::Tag do
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

  it "allows the user to use Liquid variables" do
    expect(stub_tag(:img, "'ruby.png' version:'{{ jekyll.version }}'") \
      .attr("version")).to(
        eq Jekyll::VERSION
      )
  end

  #

  it "works with alias tags" do
    expect(subject.send(:new, "image", "ruby.png", []) \
      .instance_variable_get(:@tag)).to(
        eq "img"
      )
  end

  #

  it "adds attributes" do
    expect(stub_tag("css", "bundle id:1").attr("id")).to eq(
      "1"
    )
  end

  #

  it "uses a data uri if asked to" do
    expect(stub_tag("img", "ruby.png data:uri").attr("src")).to start_with(
      "data:image/png;base64,"
    )
  end

  #

  it "convert js" do
    result = stub_tag "js", "bundle"
    expect(result.name).to eq "script"
    expect(result.attr("type")).to eq "text/javascript"
    expect(result.attr("src")).to eq "/assets/bundle.js"
  end

  #

  it "converts javascript" do
    result = stub_tag "js", "bundle"
    expect(result.name).to eq "script"
    expect(result.attr("type")).to eq "text/javascript"
    expect(result.attr("src")).to eq "/assets/bundle.js"
  end

  #

  it "converts css" do
    result = stub_tag "css", "bundle"
    expect(result.name).to eq "link"
    expect(result.attr("rel")).to eq "stylesheet"
    expect(result.attr("href")).to eq "/assets/bundle.css"
    expect(result.attr("type")).to eq "text/css"
  end

  #

  it "converts style" do
    result = stub_tag "style", "bundle"
    expect(result.name).to eq "link"
    expect(result.attr("rel")).to eq "stylesheet"
    expect(result.attr("href")).to eq "/assets/bundle.css"
    expect(result.attr("type")).to eq "text/css"
  end

  #

  it "converts stylesheet" do
    result = stub_tag "stylesheet", "bundle"
    expect(result.name).to eq "link"
    expect(result.attr("rel")).to eq "stylesheet"
    expect(result.attr("href")).to eq "/assets/bundle.css"
    expect(result.attr("type")).to eq "text/css"
  end

  #

  it "returns the source with asset_source" do
    expect(stub_tag("asset_source", "simple").text.strip).to eq(
      "body {\n  background: #000;\n}"
    )
  end

  #

  it "returns the source with asset" do
    expect(stub_tag("asset_source", "simple").text.strip).to eq(
      "body {\n  background: #000;\n}"
    )
  end

  #

  it "returns the path on asset_path" do
    expect(stub_tag("asset_path", "bundle.css").text).to eq(
      "/assets/bundle.css"
    )
  end

  #

  it "returns a url w/ CDN in production if exists and skips the prefix" do
    allow(Jekyll).to receive(:env).and_return "production"
    stub_env_config "cdn" => "//localhost", "skip_prefix_with_cdn" => true
    expect(stub_tag("img", "bundle").attr("src")).to eq(
      "//localhost/bundle.css"
    )
  end

  #

  it "returns a url w/ CDN in production" do
    allow(Jekyll).to receive(:env).and_return "production"
    stub_env_config "cdn" => "//localhost"
    expect(stub_tag("img", "bundle").attr("src")).to eq(
      "//localhost/assets/bundle.css"
    )
  end

  #

  it "adds itself to #tags on the asset" do
    @env.find_asset("bundle.css").liquid_tags.clear
    stub_tag "stylesheet", "bundle.css"
    expect(@env.find_asset("bundle.css").liquid_tags).not_to be_empty
    expect(@env.find_asset("bundle.css").liquid_tags.size).to eq 1
    expect(@env.find_asset("bundle.css").liquid_tags.first).to be_kind_of(
      subject
    )
  end

  #

  it "captures and outputs errors" do
    expect(Jekyll.logger).to receive(:error).and_return nil
    expect { stub_tag "css", "error" }.to raise_error(
      Sass::SyntaxError
    )
  end
end
