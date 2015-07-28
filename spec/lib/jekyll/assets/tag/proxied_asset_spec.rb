require "rspec/helper"

describe Jekyll::Assets::Tag::ProxiedAsset do
  let( :inst) { klass.new(@asset, @tag.args, @env, @tag) }
  let(:klass) { Jekyll::Assets::Tag::ProxiedAsset }

  before :all do
    @site  = stub_jekyll_site
    @env   = Jekyll::Assets::Env.new(@site)
    @tag   = Jekyll::Assets::Tag.send(:new, "img", "ruby.png magick:2x", [])
    @asset = @env.find_asset("ruby.png")
  end

  it "runs the proxy" do
    og_dimensions = MiniMagick::Image.open(@env.jekyll.in_source_dir("_assets/img/ruby.png")).dimensions
    dimensions    = MiniMagick::Image.open(@env.in_cache_dir(inst.digest_path)).dimensions
    expect(og_dimensions[0] * 2).to eq dimensions[0]
    expect(og_dimensions[1] * 2).to eq dimensions[1]
  end

  it "sets cached = false if the asset doesn't exist" do
    Dir[@env.in_cache_dir("ruby-*.png")].map(&FileUtils.method(:rm))
    expect(inst.cached?).to be \
      false
  end

  it "sets cached = true if the asset exists" do
    expect(inst.cached?).to be \
      true
  end

  it "provides access to the assets source" do
    expect(inst.source).not_to \
      be_empty
  end

  it "provides a digest, and bases it on the arguments" do
    expect(inst.digest).not_to be_empty
    expect(inst.digest).to eq \
      Digest::SHA2.hexdigest(@tag.args.proxies.to_s)
  end

  it "always digest the path to ensure uniqness" do
    expect(inst.logical_path).to eq \
      inst.digest_path
  end

  it "caches the file inside of the asset cache directory" do
    expect(Pathname.new(@env.in_cache_dir(inst.logical_path))).to exist
  end
end
