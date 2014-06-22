require "spec_helper"
require "jekyll-assets/font-awesome"

describe "Font Awesome integration" do
  it "should globally append font awesome paths into Sprockets environment" do
    expect(@site.assets["font-awesome.css"].to_s).to match(/fa-github/)
  end
end
