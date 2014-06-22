require "spec_helper"
require "jekyll-assets/neat"

describe "Neat integration" do
  it "should globally append neat paths into Sprockets environment" do
    expect(@site.assets["vendor/neat.css"].to_s).to match(/max-width/)
  end
end
