require "spec_helper"
require "jekyll-assets/bootstrap"

RSpec.describe "Bootstrap integration" do
  it "globally appends bootstrap paths into Sprockets environment" do
    expect(@site.assets["vendor/with_bootstrap.css"].to_s)
      .to match(/bootstrap\//)
  end
end
