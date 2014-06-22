require "spec_helper"
require "jekyll-assets/bourbon"

RSpec.describe "Bourbon integration" do
  it "globally appends bourbon paths into Sprockets environment" do
    expect(@site.assets["vendor/with_bourbon.css"].to_s)
      .to match(/linear-gradient/)
  end
end
