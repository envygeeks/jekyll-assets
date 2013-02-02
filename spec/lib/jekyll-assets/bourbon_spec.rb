require "spec_helper"
require "jekyll-assets/bourbon"


module Jekyll::AssetsPlugin
  describe "Bourbon integration" do
    it "should globally append bourbon paths into Sprockets environment" do
      asset = @site.assets["vendor/bourbon.css"].to_s

      asset.should =~ /-webkit-box-shadow/
      asset.should =~ /box-shadow/
    end
  end
end
