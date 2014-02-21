require "spec_helper"
require "jekyll-assets/bootstrap"

require 'pry'
module Jekyll::AssetsPlugin
  describe "Bootstrap integration" do
    it "should globally append bootstrap paths into Sprockets environment" do
      @site.assets["bootstrap.css"].to_s.should =~ /bootstrap\//
    end
  end
end
