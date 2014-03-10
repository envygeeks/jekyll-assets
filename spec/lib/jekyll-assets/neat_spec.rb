require "spec_helper"
require "jekyll-assets/neat"

module Jekyll::AssetsPlugin
  describe "Neat integration" do
    it "should globally append neat paths into Sprockets environment" do
      @site.assets["vendor/neat.css"].to_s.should =~ /max-width/
    end
  end
end
