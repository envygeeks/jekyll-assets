require 'spec_helper'
require 'jekyll-assets/compass'


module Jekyll::AssetsPlugin
  describe 'Compass integration' do
    it "should globally append compass paths into Sprockets environment" do
      puts @site.assets['photos.css'].to_s
    end
  end
end
