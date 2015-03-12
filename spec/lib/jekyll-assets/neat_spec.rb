require "spec_helper"

RSpec.describe "Neat integration" do
  it "globally appends neat paths into Sprockets environment" do
    Jekyll::Assets::Neat.bind
    start_site
    expect(@site.assets["vendor/with_neat.css"].to_s).to match(/max-width/)
  end
end
