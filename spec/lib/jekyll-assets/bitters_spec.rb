require "spec_helper"
require "jekyll-assets/bitters"

RSpec.describe "Bitters integration" do
  it "globally appends bitters paths into Sprockets environment" do
    expect(@site.assets["vendor/with_bitters.css"].to_s).to match(/font-size/)
  end
end
