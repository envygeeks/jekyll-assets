require "spec_helper"

RSpec.describe "Bootstrap integration" do
  it "globally appends bootstrap paths into Sprockets environment" do
    Jekyll::Assets::Bootstrap.bind
    start_site
    expect(@site.assets["vendor/with_bootstrap.css"].to_s)
      .to match(/bootstrap\//)
  end
end
