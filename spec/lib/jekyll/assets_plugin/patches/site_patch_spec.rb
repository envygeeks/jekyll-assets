require "spec_helper"


module Jekyll::AssetsPlugin
  module Patches
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

            it "should be appended to the static_files list" do
              asset = site.assets["app.css"] # make sure main asset was compiled
              asset = site.assets["noise.png"]

              site.static_files.include?(asset).should be_true
            end
          end
        end
      end


      context "#asset_path" do
        subject { site.asset_path "app.css" }

        context "with none cachebust" do
          before { site.assets_config.cachebust = :none }
          it { should match(%r{^/assets/app\.css$}) }
        end

        context "with soft cachebust" do
          before { site.assets_config.cachebust = :soft }
          it { should match(%r{^/assets/app\.css\?cb=[a-f0-9]{32}$}) }
        end

        context "with hard cachebust" do
          before { site.assets_config.cachebust = :hard }
          it { should match(%r{^/assets/app-[a-f0-9]{32}\.css$}) }
        end

        context "with unknown cachebust" do
          before { site.assets_config.cachebust = :wtf }
          it "should raise error" do
            expect { site.asset_path "app.css" }.to raise_error
          end
        end


        context "with query part in requested filename" do
          subject { site.asset_path "app.css?foo=bar" }

          context "and none cachebust" do
            before { site.assets_config.cachebust = :none }
            it { should match(%r{^/assets/app\.css\?foo=bar$}) }
          end

          context "and soft cachebust" do
            before { site.assets_config.cachebust = :soft }
            it { should match(%r{^/assets/app\.css\?cb=[a-f0-9]{32}&foo=bar$}) }
          end

          context "and hard cachebust" do
            before { site.assets_config.cachebust = :hard }
            it { should match(%r{^/assets/app-[a-f0-9]{32}\.css\?foo=bar$}) }
          end
        end


        context "with anchor part in requested filename" do
          subject { site.asset_path "app.css#foobar" }

          context "and none cachebust" do
            before { site.assets_config.cachebust = :none }
            it { should match(%r{^/assets/app\.css#foobar$}) }
          end

          context "and soft cachebust" do
            before { site.assets_config.cachebust = :soft }
            it { should match(%r{^/assets/app\.css\?cb=[a-f0-9]{32}#foobar$}) }
          end

          context "and hard cachebust" do
            before { site.assets_config.cachebust = :hard }
            it { should match(%r{^/assets/app-[a-f0-9]{32}\.css#foobar$}) }
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


      it "should regenerate assets upon multiple #process" do
        @site.assets_config.cachebust = :none
        2.times { @site.process }

        @dest.join("assets", "app.css").exist?.should be_true
      end

      context "#gzip" do
        subject { site.assets_config }

        it "should generate a static assets if gzip is enabled" do
          @site.assets_config.gzip = true
          @site.process
          @dest.join("assets", "app.css.gz").exist?.should be_true
        end

        it "should not generate a static assets if gzip is enabled" do
          @site.assets_config.gzip = false
          @site.process
          @dest.join("assets", "app.css.gz").exist?.should be_false
        end

      end

      it "should be included into Jekyll::Site" do
        Jekyll::Site.included_modules.should include SitePatch
      end
    end
  end
end
