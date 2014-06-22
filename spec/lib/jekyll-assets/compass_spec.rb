require "spec_helper"
require "jekyll-assets/compass"

describe "Compass integration" do
  it "should globally append compass paths into Sprockets environment" do
    expect(@site.assets["vendor/compass.css"].to_s).to match(/linear-gradient/)
  end
end
