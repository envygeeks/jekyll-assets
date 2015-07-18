require "rspec/helper"
require "nokogiri"

describe Jekyll::Assets::Tag do
  let :site do
    stub_jekyll_site
  end

  def stub
    silence_stdout do
      site.process
    end
  end

  before :each do
    stub
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

  context :asset_path do
    it "returns simply just an asset path" do
      html.xpath("//body/p[contains(., '/assets/bundle')]").each do |v|
        expect(v.text).to match(
          %r!\A/assets/bundle\.(css|js)\Z!
        )
      end
    end
  end
end
