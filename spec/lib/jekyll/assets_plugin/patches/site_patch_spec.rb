require "spec_helper"

# rubocop:disable LineLength

RSpec.describe Jekyll::AssetsPlugin::Patches::SitePatch do
  let(:site) do
    Jekyll::Site.new Jekyll.configuration({
      "source"  => fixtures_path.to_s,
      "dirname" => "foobar",
      "assets"  => {
        "sources" => %w(foobar _assets)
      }
    })
  end

  context "#assets" do
    subject { site.assets }
    it { is_expected.to be_a_kind_of ::Sprockets::Environment }

    context "#cache_path" do
      let(:source_path) { Pathname.new site.source }
      subject           { site.assets.cache_path }

      it { is_expected.to eq source_path.join(".jekyll-assets-cache") }
    end

    context "calling #asset_path within assets" do
      context "when requested file not found" do
        it "raises a NotFound error" do
          expect { site.assets["should_fail.css"] }
            .to raise_error Jekyll::AssetsPlugin::Environment::AssetNotFound
        end
      end

      context "when requested file found" do
        it "has proper asset path" do
          expect(site.assets["app.css"].to_s)
            .to match(%r{url\(/assets/noise-[a-f0-9]{32}\.png\)})
        end
      end

      context "when passed a blank path" do
        it "is blank" do
          expect(site.assets["should_be_blank.css"].to_s)
            .to match(/url\(\)/)
        end
      end
    end
  end

  context "#asset_path" do
    subject { site.asset_path "app.css" }

    context "with none cachebust" do
      before { site.assets_config.cachebust = :none }
      it { is_expected.to match(%r{^/assets/app\.css$}) }
    end

    context "with soft cachebust" do
      before { site.assets_config.cachebust = :soft }
      it { is_expected.to match(%r{^/assets/app\.css\?cb=[a-f0-9]{32}$}) }
    end

    context "with hard cachebust" do
      before { site.assets_config.cachebust = :hard }
      it { is_expected.to match(%r{^/assets/app-[a-f0-9]{32}\.css$}) }
    end

    context "with unknown cachebust" do
      before { site.assets_config.cachebust = :wtf }
      it "raises error" do
        expect { site.asset_path "app.css" }.to raise_error
      end
    end

    context "with query part in requested filename" do
      subject { site.asset_path "app.css?foo=bar" }

      context "and none cachebust" do
        before { site.assets_config.cachebust = :none }
        it { is_expected.to match(%r{^/assets/app\.css\?foo=bar$}) }
      end

      context "and soft cachebust" do
        before { site.assets_config.cachebust = :soft }
        it { is_expected.to match %r{^/assets/app\.css\?cb=[a-f0-9]{32}&foo=bar$} }
      end

      context "and hard cachebust" do
        before { site.assets_config.cachebust = :hard }
        it { is_expected.to match(%r{^/assets/app-[a-f0-9]{32}\.css\?foo=bar$}) }
      end
    end

    context "with anchor part in requested filename" do
      subject { site.asset_path "app.css#foobar" }

      context "and none cachebust" do
        before { site.assets_config.cachebust = :none }
        it { is_expected.to match(%r{^/assets/app\.css#foobar$}) }
      end

      context "and soft cachebust" do
        before { site.assets_config.cachebust = :soft }
        it { is_expected.to match(%r{^/assets/app\.css\?cb=[a-f0-9]{32}#foobar$}) }
      end

      context "and hard cachebust" do
        before { site.assets_config.cachebust = :hard }
        it { is_expected.to match(%r{^/assets/app-[a-f0-9]{32}\.css#foobar$}) }
      end
    end
  end

  context "#assets_config" do
    subject { site.assets_config }
    it { is_expected.to be_an_instance_of Jekyll::AssetsPlugin::Configuration }

    it "populated with `assets` section of config" do
      expect(site.assets_config.dirname).not_to eq "foobar"
      expect(site.assets_config.sources).to include "foobar"
    end
  end

  it "regenerates assets upon multiple #process" do
    @site.assets_config.cachebust = :none
    2.times { @site.process }
    expect(@dest.join "assets", "app.css").to exist
  end

  context "with cache" do
    def site
      Jekyll::Site.new(Jekyll.configuration({
        "source"      => fixtures_path.to_s,
        "assets"      => { "cache" => true, "cachebust" => :none },
        "destination" => @dest.to_s
      }))
    end

    after do
      site.assets.cache_path.rmtree if site.assets.cache_path.exist?
    end

    it "regenerates static assets upon multiple #process" do
      2.times { site.process }
      expect(@dest.join "assets", "noise.png").to exist
    end
  end

  context "#gzip" do
    subject { site.assets_config }

    it "generates a static assets if gzip is enabled" do
      @site.assets_config.gzip = true
      @site.process

      expect(@dest.join "assets", "app.css.gz").to exist
    end

    it "does not generate a static assets if gzip is enabled" do
      @site.assets_config.gzip = false
      @site.process

      expect(@dest.join "assets", "app.css.gz").to_not exist
    end

  end

  it "is included into Jekyll::Site" do
    expect(Jekyll::Site.included_modules).to include described_class
  end
end
