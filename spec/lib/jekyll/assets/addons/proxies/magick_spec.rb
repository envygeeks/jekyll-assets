require "rspec/helper"
describe "Magick Image Proxy" do
  before :all do
    @site  = stub_jekyll_site
    @env   = Jekyll::Assets::Env.new(@site)
    @asset = @env.find_asset("ubuntu-tv-wikimedia.png")
  end

  def stub_tag(*args)
    Jekyll::Assets::Liquid::Tag.send(:new, "img", "ubuntu-tv-wikimedia.png #{args.join(" ")}", []). \
      render(OpenStruct.new(:registers => { :site => @site }))
  end

  def get_asset(html)
    Pathname.new(@env.in_cache_dir(fragment(html).children.first.attr("src").gsub(/^#{ \
      Regexp.escape(@env.prefix)}\//, "")))
  end

  def as_magick(path)
    MiniMagick::Image.open(path.to_s)
  end

  it "allows a user to adjust quality" do
    asset = get_asset(stub_tag("magick:quality:99"))
    expect(Pathname.new(@asset.filename).size).to be > \
      asset.size
  end

  it "allows the user to resize" do
    expect(as_magick(get_asset(stub_tag("magick:resize:10"))). \
      info(:dimensions).first).to eq 10
  end

  context "boolean resizes" do
    def dimensions(asset)
      as_magick(asset).info(:dimensions)
    end

    it "allows 2x" do
      odimensions = dimensions(@asset.pathname)
      expect(dimensions(get_asset(stub_tag("magick:2x")))).to eq \
        [odimensions.first * 2, odimensions.last * 2]
    end

    it "allows 4x" do
      odimensions = dimensions(@asset.pathname)
      expect(dimensions(get_asset(stub_tag("magick:4x")))).to eq \
        [odimensions.first * 4, odimensions.last * 4]
    end

    it "allows half" do
      odimensions = dimensions(@asset.pathname)
      expect(dimensions(get_asset(stub_tag("magick:half")))).to eq \
        [odimensions.first / 2, odimensions.last / 2]
    end
  end
end
