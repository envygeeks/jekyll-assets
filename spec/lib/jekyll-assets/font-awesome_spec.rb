# rubocop: disable Style/FileName

require "spec_helper"
require "jekyll-assets/font-awesome"

RSpec.describe "Font Awesome integration" do
  it "globally appends font awesome paths into Sprockets environment" do
    expect(@site.assets["font-awesome.css"].to_s).to match(/fa-github/)
  end
end
