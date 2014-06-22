require "spec_helper"
require "jekyll-assets/compass"

RSpec.describe "Compass integration" do
  it "globally appends compass paths into Sprockets environment" do
    expect(@site.assets["vendor/with_compass.css"].to_s)
      .to match(/linear-gradient/)
  end
end
