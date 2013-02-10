require "spec_helper"


module Jekyll::AssetsPlugin
  describe SitePatch do
    let(:site) do
      Class.new(Jekyll::Site) do
        include SitePatch

        def initialize
          self.reset
        end

        def config
          @config ||= {
            "dirname" => "foobar",
            "assets"  => {
              "sources" => [ "foobar", "_assets" ]
            }
          }
        end

        def source
          @source ||= RSpecHelpers.fixtures_path.to_s
        end
      end.new
    end

    context "#assets" do
      subject { site.assets }
      it { should be_a_kind_of Sprockets::Environment }

      context "calling #asset_path within assets" do
        context "when requested file not found" do
          it "should raise a NotFound error" do
            Proc.new do
              site.assets["should_fail.css"]
            end.should raise_error(Environment::AssetNotFound)
          end
        end

        context "when requested file found" do
          it "should have proper asset path" do
            noise_img_re = %r{url\(/assets/noise-[a-f0-9]{32}\.png\)}
            site.assets["app.css"].to_s.should match(noise_img_re)
          end

          it "should be appended to the static files list" do
            asset = site.assets["app.css"] # make sure main asset was compiled
            asset = site.assets["noise.png"]

            site.static_files.include?(asset).should be_true
          end
        end
      end

      context "with Liquid markup within assets" do
        it "should be rendered" do
          site.assets["app.js"].to_s.should match(/noise-[a-f0-9]{32}\.png/)
        end
      end
    end


    context "#asset_path" do
      context "with none cachebust" do
        before { site.assets_config.cachebust = :none }
        subject { site.asset_path "app.css" }
        it { should match(%r{^/assets/app\.css$}) }
      end

      context "with soft cachebust" do
        before { site.assets_config.cachebust = :soft }
        subject { site.asset_path "app.css" }
        it { should match(%r{^/assets/app\.css\?cb=[a-f0-9]{32}$}) }
      end

      context "with hard cachebust" do
        before { site.assets_config.cachebust = :hard }
        subject { site.asset_path "app.css" }
        it { should match(%r{^/assets/app-[a-f0-9]{32}\.css$}) }
      end

      context "with unknown cachebust" do
        before { site.assets_config.cachebust = :wtf }
        it "should raise error" do
          expect { site.asset_path "app.css" }.to raise_error
        end
      end
    end

    context "#assets_config" do
      subject { site.assets_config }
      it { should be_an_instance_of Configuration }

      it "should been populated with `assets` section of config" do
        site.assets_config.dirname.should_not == "foobar"
        site.assets_config.sources.should include "foobar"
      end
    end

    it "should be included into Jekyll::Site" do
      Jekyll::Site.included_modules.should include SitePatch
    end
  end
end
