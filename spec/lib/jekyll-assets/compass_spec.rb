require 'spec_helper'
require 'jekyll-assets/compass'


module Jekyll::AssetsPlugin
  describe 'Compass integration' do
    it "should globally append compass paths into Sprockets environment" do
      asset = @site.assets['vendor/compass.css'].to_s

      asset.should =~ /-webkit-box-shadow/
      asset.should =~ /-moz-box-shadow/
      asset.should =~ /box-shadow/
    end
  end
end
