require "spec_helper"


module Jekyll::AssetsPlugin
  describe AssetFile do
    context "#destination" do
      subject do
        AssetFile.new(@site, @site.assets["app.css"]).destination @dest.to_s
      end

      context "with none cachebust" do
        before { @site.assets_config.cachebust = :none }
        it { should match(%r{/app\.css$}) }
      end

      context "with soft cachebust" do
        before { @site.assets_config.cachebust = :soft }
        it { should match(%r{/app\.css$}) }
      end

      context "with hard cachebust" do
        before { @site.assets_config.cachebust = :hard }
        it { should match %r{/app-[0-9a-f]{32}\.css$} }
      end

      context "with unknown cachebust" do
        before { @site.assets_config.cachebust = :wtf }
        it "should raise error" do
          expect { @site.asset_path "app.css" }.to raise_error
        end
      end
    end
  end
end
