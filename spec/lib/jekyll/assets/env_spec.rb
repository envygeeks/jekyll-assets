require "rspec/helper"

describe Jekyll::Assets::Env do
  let  :env do
    Jekyll::Assets::Env.new(site)
  end

  let :site do
    stub_jekyll_site
  end

  it "adds the jekyll instance" do
    expect(env.jekyll).to eq site
  end

  it "creates a new used set" do
    expect(env.used).to be_kind_of Set
    expect(env.used).to be_empty
  end

  context :prefix_path do
    it "returns a cdn w/ prefix if in production mode" do
      allow(Jekyll).to receive(:env).and_return "production"
      stub_asset_config "cdn" => "//localhost"
      expect(env.prefix_path).to eq "//localhost/assets"
    end

    context "with the option skip_prefix_with_cdn" do
      it "does not skip the prefix if there is no cdn" do
        allow(Jekyll).to receive(:env).and_return "production"
        stub_asset_config "skip_prefix_with_cdn" => true
        expect(env.prefix_path).to eq "/assets"
      end

      it "skips the prefix only when in production" do
        stub_asset_config "skip_prefix_with_cdn" => true, "cdn" => "//localhost"
        expect(env.prefix_path).to eq "/assets"
      end

      it "skips the prefix when in production" do
        allow(Jekyll).to receive(:env).and_return "production"
        stub_asset_config "skip_prefix_with_cdn" => true, "cdn" => "//localhost"
        expect(env.prefix_path).to eq "//localhost/"
      end
    end
  end

  context "digesting" do
    context "in production" do
      it "digests by default" do
        allow(Jekyll).to receive(:env).and_return "production"
        expect(env.digest?).to be true
        expect(env.send(:as_path, env.find_asset("bundle.css"))).to match( \
          /bundle-([a-zA-Z0-9]+)\.css\Z/)
      end

      it "allows the user to disable digesting" do
        allow(Jekyll).to receive(:env).and_return "production"
        stub_asset_config "digest" => false
        expect(env.digest?).to be false
        expect(env.send(:as_path, env.find_asset("bundle.css"))).to eq \
          site.in_dest_dir(env.asset_config["prefix"], "bundle.css")
      end
    end

    context "in development/test" do
      it "does not digest by default" do
        expect(env.digest?).to be false
        expect(env.send(:as_path, env.find_asset("bundle.css"))).to eq \
          site.in_dest_dir(env.asset_config["prefix"], "bundle.css")
      end

      it "allows people to enable digesting" do
        stub_asset_config "digest" => true
        expect(env.digest?).to be true
        expect(env.send(:as_path, env.find_asset("bundle.css"))).to match( \
          /bundle-([a-zA-Z0-9]+)\.css\Z/)
      end
    end
  end

  it "overrides the default object cache" do
    expect(env.cached).to be_kind_of \
      Jekyll::Assets::Cached
  end

  it "sets the logger" do
    expect(env.logger).to be_kind_of \
      Jekyll::Assets::Logger
  end

  it "patches asset context" do
    expect(env.context_class.method_defined?(:_old_asset_path)).to be true
  end

  context :context_class do
    context :_asset_path do
      it "adds the asset to the env#used set" do
        env.find_asset "context", :accept => "text/css"

        expect(env.used.size).to eq 1
        expect(env.used.first.pathname.fnmatch?("*/context.jpg")).to eq true
      end
    end
  end

  it "allows user to set their own sources" do
    stub_asset_config "sources" => %W(_foo/bar)
    results = env.paths.grep(/\A#{Regexp.union(site.in_source_dir)}/)
    expect(results).to include site.in_source_dir("_foo/bar")
    expect(results.size).to eq 1
  end

  it "sets up a file cache" do
    expect(env.cache.instance_variable_get(:@cache_wrapper).cache).to \
      be_kind_of Sprockets::Cache::FileStore
  end

  it "it compresses if asked to" do
    stub_asset_config "compress" => { "js" => true, "css" => true }
    expect(env. js_compressor).to eq Sprockets::UglifierCompressor
    expect(env.css_compressor).to eq Sprockets::    SassCompressor
  end

  context :compress? do
    it "should default to compression being off" do
      expect(env.compress?("css")).to eq false
      expect(env.compress?( "js")).to eq false
    end

    it "should allow compression if the user wants it" do
      stub_asset_config "compress" => { "css" => true, "js" => true }
      expect(env.compress?("css")).to be true
      expect(env.compress?( "js")).to be true
    end
  end

  context do
       let(:path) { site.in_dest_dir(Jekyll::Assets::Configuration::DEVELOPMENT["prefix"]) }
    before(:each) { site.process }

    it "writes user assets" do
      expect(Dir[File.join(path, "*")]).not_to be_empty
    end

    it "writes cached assets" do
      FileUtils.rm_r(path)
      site.sprockets.used. \
        clear

      site.sprockets.class.digest_cache.each do |k, v|
        site.sprockets.class.digest_cache[k] = "ShouldNotMatch"
      end

      site.sprockets.write_all
      expect(Dir[File.join(path, "*")].size).to eq \
        site.sprockets.class.digest_cache.keys.size
    end

    it "writes missing assets" do
      file = Dir[File.join(path, "*")][0]
      FileUtils.rm(file)

      site.sprockets.write_all
      expect(Pathname.new(file)).to exist
    end
  end
end
