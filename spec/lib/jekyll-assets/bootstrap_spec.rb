require "spec_helper"
require "jekyll-assets/bootstrap"

describe "Bootstrap integration" do
  it "should globally append bootstrap paths into Sprockets environment" do
    @site.assets["bootstrap.css"].to_s.should =~ /bootstrap\//
  end
end
