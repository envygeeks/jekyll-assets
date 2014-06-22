require "spec_helper"
require "jekyll-assets/bourbon"

describe "Bourbon integration" do
  it "should globally append bourbon paths into Sprockets environment" do
    expect(@site.assets["vendor/bourbon.css"].to_s).to match(/linear-gradient/)
  end
end
