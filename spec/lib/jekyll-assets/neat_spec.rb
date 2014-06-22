require "spec_helper"
require "jekyll-assets/neat"

RSpec.describe "Neat integration" do
  it "globally appends neat paths into Sprockets environment" do
    expect(@site.assets["vendor/with_neat.css"].to_s).to match(/max-width/)
  end
end
