require "rspec/helper"

describe Jekyll::Assets::Env do
  let :site do
    stub_jekyll_site
  end

  let :env do
    Jekyll::Assets::Env.new(
      site
    )
  end

  context :jekyll do
    it "responds" do
      expect(env).to respond_to(
        :jekyll
      )
    end

    it "matches site" do
      expect(env.jekyll).to eq(
        site
      )
    end
  end

  context :used do
    it "is a new set" do
      expect(env.used).to be_kind_of(
        Set
      )
    end
  end

  context :digest? do
    it "should not digest on digest = false config" do
      old_value = site.config["assets"]
      site.config["assets"] = {
        "digest" => false
      }

      expect(env.digest?).to eq false
      site.config["assets"] = old_value
    end

    it "should digest on digest = true config" do
      allow(Jekyll).to receive(:env).and_return("development")
      old_value = site.config["assets"]
      site.config["assets"] = {
        "digest" => true
      }

      expect(env.digest?).to eq true
      site.config["assets"] = old_value
    end

    context "Jekyll.env == production" do
      it "digests by default" do
        allow(Jekyll).to receive(:env).and_return "production"
        old_value = site.config.delete("assets")
        expect(env.digest?).to eq true
        site.config["assets"] = old_value
      end
    end

    context "Jekyll.env == test | development" do
      it "doesn't not digest by default" do
        %W(development test).each do |v|
          allow(Jekyll).to receive(:env).and_return v
          old_value = site.config.delete("assets")
          expect(env.digest?).to eq false
          site.config["assets"] = old_value
        end
      end
    end
  end

  it "overrides the default cache" do
    expect(env.cached).to be_kind_of(
      Jekyll::Assets::Cached
    )
  end

  it "sets the logger" do
    expect(env.logger).to be_kind_of(
      Jekyll::Assets::Logger
    )
  end

  it "patches asset context" do
    expect(env.context_class.method_defined?(:_old_asset_path)).to eq(
      true
    )
  end

  context :context_class do
    context :_asset_path do
      it "adds the asset to the used set" do
        env.find_asset("context", {
          :accept => "text/css"
        })

        expect(env.used.size).to eq 1
        expect(env.used.first.pathname.fnmatch?("*/context.jpg")).to eq(
          true
        )
      end
    end
  end

  context :config do
    it "allows users to set default sources" do
      old_value = site.config.delete("assets")
      site.config["assets"] = {
        "sources" => [
          "_foo/bar"
        ]
      }

      result = env.class.new(site).paths.grep(
        %r!fixture/_foo/bar\Z!
      )

      expect(result.size).to eq(1)
      site.config["assets"] = old_value
    end
  end

  it "sets up a cache" do
    expect(env.cache.instance_variable_get(:@cache_wrapper).cache).to be_kind_of(
      Sprockets::Cache::FileStore
    )
  end

  it "sets the JS compressor if asked to" do
    old_value = site.config.delete("assets")
    site.config["assets"] = {
      "compress" => {
        "js" => true
      }
    }

    result = env.class.new(site)
    expect(result.js_compressor).to eq(Sprockets::UglifierCompressor)
    site.config["assets"] = old_value
  end

  it "sets the CSS compressor if ask to" do
    old_value = site.config.delete("assets")
    site.config["assets"] = {
      "compress" => {
        "css" => true
      }
    }

    result = env.class.new(site)
    expect(result.css_compressor).to eq(Sprockets::SassCompressor)
    site.config["assets"] = old_value
  end

  context :compress? do
    it "should default to compression being off" do
      expect(env.compress?("css")).to eq false
      expect(env.compress?( "js")).to eq false
    end

    it "should allow compression if the user wants it" do
      allow(Jekyll).to receive(:env).and_return "development"
      old_value = site.config.delete("assets")
      site.config["assets"] = {
        "compress" => {
          "css" => true,
          "js"  => true
        }
      }

      expect(env.compress?("css")).to eq true
      expect(env.compress?( "js")).to eq true
      site.config["assets"] = old_value
    end
  end

  it "transpiles es6" do
    expect(env.find_asset("transpile.js").to_s.strip.gsub(/$\n+/, " ")).to eq(
      %Q{"use strict"; var Hello = Symbol();}
    )
  end

  it "prefixes css" do
    result = env.find_asset("prefix.css").to_s
    expect(result).to match %r!-webkit-order:\s+1!
    expect(result).to match %r!-ms-flex-order:\s+1!
  end
end
