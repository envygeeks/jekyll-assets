require "spec_helper"
require "jekyll-assets/font-awesome"

module Jekyll::AssetsPlugin
  describe "Font Awesome integration" do
    it "should globally append font awesome paths into Sprockets environment" do
      @site.assets["font-awesome.css"].to_s.should =~ /fa-github/
    end
  end
end
