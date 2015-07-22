require "rspec/helper"
require "nokogiri"

# XXX: This entire file can be switched from writing to simply hacking
#   the Liquid tag chain the way we did with the CDN, this would probably
#   speed up our tests a bit because we reduce some writing.

describe Jekyll::Assets::Tag do
  def site
    @_site ||= \
    stub_jekyll_site_with_processing
  end

  before :all do
    site
  end

  def file
    get_stubbed_file(
      "index.html"
    )
  end

  def html
    Nokogiri::HTML(
      file
    )
  end

  it "adds attributes" do
    html.xpath("//head/*[self::script or self::link]").each do |v|
      expect(v.attr("id").to_i).to be > 0
    end
  end

  it "converts js and javascript" do
    result = html.xpath("//head/script[@src='/assets/bundle.js']")
    expect(result.size).to eq(2)
  end

  it "converts style, css and stylesheet" do
    result = html.xpath("//head/link[@href='/assets/bundle.css']")
    expect(result.size).to eq(3)
  end

  context :css_link do
    it "adds text/css" do
      html.xpath("//head/link[@href='/assets/bundle.css']").each do |v|
        expect(v.attr("type")).to eq "text/css"
      end
    end

    it "adds rel stylesheet to links" do
      html.xpath("//head/link[@href='/assets/bundle.css']").each do |v|
        expect(v.attr("rel")).to eq "stylesheet"
      end
    end
  end

  it "returns simply just an asset path" do
    html.xpath("//body/p[contains(., '/assets/bundle')]").each do |v|
      expect(v.text).to match(
        %r!\A/assets/bundle\.(css|js)\Z!
      )
    end
  end

  context "env == production" do
    before do
      allow(Jekyll).to receive(:env).and_return "production"
    end

    let :site do
      stub_jekyll_site({
        "assets"      => {
          "cdn"       => "https://cdn.example.com/",
          "digest"    => false,
          "compress"  => {
            "css"     => false,
            "js"      => false
          }
        }
      })
    end

    let :sprockets do
      site.sprockets = Jekyll::Assets::Env.new(
        site
      )
    end

    it "returns a url w/ CDN if it exists" do
      site.sprockets = sprockets
      result = Jekyll::Assets::Tag.send(:new, "css", "bundle", []).render(
        OpenStruct.new({
          :registers => {
            :site => site
          }
        })
      )

      expect(result).to eq(
        %Q{<link type="text/css" rel="stylesheet" href="https://cdn.example.com/assets/bundle.css">}
      )
    end
  end

  it "adds tag stuff as [tag] on metadata" do
    asset = site.sprockets.used.select { |v| v.logical_path =~ /bundle\.css/ }[0]
    expect(asset.metadata[:tag]).to be_a(
      Jekyll::Assets::Tag::Parser
    )
  end
end
