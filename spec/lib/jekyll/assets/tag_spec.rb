require "rspec/helper"
require "nokogiri"

describe Jekyll::Assets::Tag do
  before :all do
    @site = stub_jekyll_site
    @env  = Jekyll::Assets::Env.new(@site)
    @site_struct = OpenStruct.new(:registers => {
      :sprockets => @env, :site => @site
    })
  end

  def stub_tag(tag, data)
    fragment(Jekyll::Assets::Tag.send(:new, tag, data, []).render( \
      @site_struct))
  end

  def fragment(html)
    Nokogiri::HTML.fragment(html).children. \
      first
  end

  it "adds a default alt attribute to img" do
    expect(stub_tag("img", "ruby.png").attr("alt")).to eq \
      "ruby.png"
  end

  it "adds attributes" do
    expect(stub_tag("css", "bundle id:1").attr("id")).to eq \
      "1"
  end

  it "uses a data uri if asked to" do
    expect(stub_tag("img", "ruby.png data:uri").attr("src")).to match \
      %r!\Adata:image\/png;base64,!
  end

  it "convert js" do
    result = stub_tag "js", "bundle"
    expect(result.name).to eq "script"
    expect(result.attr("type")).to eq "text/javascript"
    expect(result.attr("src")).to eq "/assets/bundle.js"
  end

  it "converts javascript" do
    result = stub_tag "js", "bundle"
    expect(result.name).to eq "script"
    expect(result.attr("type")).to eq "text/javascript"
    expect(result.attr("src")).to eq "/assets/bundle.js"
  end

  it "converts css" do
    result = stub_tag "css", "bundle"
    expect(result.name).to eq "link"
    expect(result.attr("rel")).to eq "stylesheet"
    expect(result.attr("href")).to eq "/assets/bundle.css"
    expect(result.attr("type")).to eq "text/css"
  end

  it "converts style" do
    result = stub_tag "style", "bundle"
    expect(result.name).to eq "link"
    expect(result.attr("rel")).to eq "stylesheet"
    expect(result.attr("href")).to eq "/assets/bundle.css"
    expect(result.attr("type")).to eq "text/css"
  end

  it "converts stylesheet" do
    result = stub_tag "stylesheet", "bundle"
    expect(result.name).to eq "link"
    expect(result.attr("rel")).to eq "stylesheet"
    expect(result.attr("href")).to eq "/assets/bundle.css"
    expect(result.attr("type")).to eq "text/css"
  end

  it "returns the path on asset_path" do
    expect(stub_tag("asset_path", "bundle.css").text).to eq "/assets/bundle.css"
  end

  it "returns a url w/ CDN in production if exists and skips the prefix" do
    allow(Jekyll).to receive(:env).and_return "production"
    stub_env_config "cdn" => "//localhost", "skip_prefix_with_cdn" => true
    expect(stub_tag("img", "bundle").attr("src")).to eq \
      "//localhost/bundle.css"
  end

  it "returns a url w/ CDN in production" do
    allow(Jekyll).to receive(:env).and_return "production"
    stub_env_config "cdn" => "//localhost"
    expect(stub_tag("img", "bundle").attr("src")).to eq \
      "//localhost/assets/bundle.css"
  end

  it "adds tag stuff as [:tag] on metadata" do
    stub_tag "stylesheet", "bundle.css"
    expect(@env.find_asset("bundle.css").metadata[:tag]).to be_kind_of \
      Jekyll::Assets::Tag::Parser
  end

  it "captures and outputs errors" do
    expect(Jekyll.logger).to receive(:error).and_return nil
    expect { stub_tag "css", "error" }.to raise_error Sass::SyntaxError
  end
end
