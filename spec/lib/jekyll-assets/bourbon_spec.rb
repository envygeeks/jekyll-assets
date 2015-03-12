require "spec_helper"

RSpec.describe "Bourbon integration" do
  it "globally appends bourbon paths into Sprockets environment" do
    Jekyll::Assets::Bourbon.bind
    start_site
    expect(@site.assets["vendor/with_bourbon.css"].to_s)
      .to match(/linear-gradient/)
  end
end
