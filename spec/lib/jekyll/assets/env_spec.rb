require "rspec/helper"

describe Jekyll::Assets::Env do
  let( :uncached_env) { Jekyll::Assets::Env.new(uncached_site) }
  let(:path) { uncached_site.in_dest_dir("/assets") }
  let(:uncached_site) { stub_jekyll_site }
  before :each, :process => true do
    uncached_site.process
  end

  before :all do
    @site = stub_jekyll_site
     @env = Jekyll::Assets::Env.new(@site)
  end

  it "does not let you use erb to process" do
    expect(@env.find_asset("failed.scss.erb").to_s).to eq \
      %Q{body { you: <%= "failed" %> }\n}
  end

  it "adds the current Jekyll instance" do
    expect(@env.jekyll).to eq @site
  end

  it "creates a new used set for assets that have been used" do
    expect(@env.used).to be_kind_of Set
    expect(@env.used).to be_empty
  end

  it "returns a path with the CDN and prefix in production" do
    allow(Jekyll).to receive(:env).and_return "production"
    stub_asset_config "cdn" => "//localhost"
    expect(@env.prefix_path).to eq "//localhost/assets"
  end

  it "skips the prefix in production if skip_prefix_with_cdn => true" do
    stub_asset_config "skip_prefix_with_cdn" => true, "cdn" => "//localhost"
    expect(@env.prefix_path).to eq "/assets"
  end

  it "does not use a cdn in development mode" do
    expect(@env.prefix_path).to eq "/assets"
  end

  it "digests by default in production" do
    allow(Jekyll).to receive(:env).and_return "production"
    expect(uncached_env.digest?).to be true
    expect(uncached_env.send(:as_path, uncached_env.find_asset("bundle.css"))). \
      to match %r!bundle-([a-zA-Z0-9]+)\.css\Z!
  end

  it "allows a user to disable digesting in production" do
    allow(Jekyll).to receive(:env).and_return "production"
    stub_asset_config "digest" => false
    expect(@env.digest?).to be false
    expect(@env.send(:as_path, @env.find_asset("bundle.css"))).to eq \
      @site.in_dest_dir(@env.asset_config["prefix"], "bundle.css")
  end

  it "does not enable digesting by default in development" do
    expect(@env.digest?).to be false
    expect(@env.send(:as_path, @env.find_asset("bundle.css"))).to eq \
      @site.in_dest_dir(@env.asset_config["prefix"], "bundle.css")
  end

  it "allows you to enable digesting in development" do
    stub_asset_config "digest" => true
    expect(@env.digest?).to be true
    expect(@env.send(:as_path, @env.find_asset("bundle.css"))).to match \
      %r!bundle-([a-zA-Z0-9]+)\.css\Z!
  end

  it "overrides the default object cache" do
    expect(@env.cached).to be_kind_of \
      Jekyll::Assets::Cached
  end

  it "sets the sprockets logger to use Jekyll's logger" do
    expect(@env.logger).to be_kind_of \
      Jekyll::Assets::Logger
  end

  it "patches asset context so we can track used assets in assets" do
    expect(@env.context_class.method_defined?(:_old_asset_path)).to be true
  end

  context "#context_class" do
    context "#_asset_path" do
      it "adds the asset to the env#used set" do
        @env.find_asset "context", :accept => "text/css"
        expect(@env.used.size).to eq 1
        expect(@env.used.first.pathname.fnmatch?("*/context.jpg")).to eq \
          true
      end
    end
  end

  it "allows user to set their own asset locations" do
    stub_asset_config uncached_site, "sources" => %W(_foo/bar)
    results = uncached_env.paths.grep(/\A#{Regexp.union(uncached_site.in_source_dir)}/)
    expect(results).to include uncached_site.in_source_dir("_foo/bar")
    expect(results.size).to eq 1
  end

  it "sets up a Sprockets FileStore cache for speed" do
    expect(@env.cache.instance_variable_get(:@cache_wrapper).cache).to \
      be_kind_of Sprockets::Cache::FileStore
  end

  it "compresses if asked to regardless of environment" do
    stub_asset_config uncached_site, "compress" => { "js" => true, "css" => true }
    expect(uncached_env. js_compressor).to eq Sprockets::UglifierCompressor
    expect(uncached_env.css_compressor).to eq Sprockets::SassCompressor
    expect(uncached_env.compress?("css")).to eq true
    expect(uncached_env.compress?( "js")).to eq true
  end

  it "does not default to compression in development" do
    expect(uncached_env. js_compressor).to be_nil
    expect(uncached_env.css_compressor).to be_nil
    expect(uncached_env.compress?("css")).to eq false
    expect(uncached_env.compress?( "js")).to eq false
  end

  it "defaults to compression being enabled in production" do
    allow(Jekyll).to receive(:env).and_return "production"
    expect(uncached_env. js_compressor).to eq Sprockets::UglifierCompressor
    expect(uncached_env.css_compressor).to eq Sprockets::SassCompressor
    expect(uncached_env.compress?("css")).to eq true
    expect(uncached_env.compress?( "js")).to eq true
  end

  it "allows you to disable compression in production" do
    allow(Jekyll).to receive(:env).and_return "production"
    stub_asset_config uncached_site, "compress" => {
      "js" => false, "css" => false
    }

    expect(uncached_env. js_compressor).to be_nil
    expect(uncached_env.css_compressor).to be_nil
    expect(uncached_env.compress?("css")).to eq false
    expect(uncached_env.compress?( "js")).to eq false
  end

  it "writes the assets the user requests it to write", :process => true do
    expect(Dir[File.join(path, "*")]).not_to be_empty
  end

  it "writes cached assets on a simple refresh", :process => true do
    FileUtils.rm_r(path)

    uncached_site.sprockets.used.clear
    uncached_site.sprockets.class.digest_cache.each do |k, v|
      uncached_site.sprockets.class.digest_cache[k] = "ShouldNotMatch"
    end

    uncached_site.sprockets.write_all
    expect(Dir[File.join(path, "*")].size).to eq \
      uncached_site.sprockets.class.digest_cache.keys.size
  end

  it "writes missing assets even when cached", :process => true do
    file = Dir[File.join(path, "*")][0]
    FileUtils.rm(file)

    uncached_site.sprockets.write_all
    expect(Pathname.new(file)).to exist
  end
end
