require "spec_helper"

RSpec.describe "Compass integration" do
  it "globally appends compass paths into Sprockets environment" do
    Jekyll::Assets::Compass.bind
    start_site
    expect(@site.assets["vendor/with_compass.css"].to_s)
      .to match(/linear-gradient/)
  end
end
