# rubocop: disable Style/FileName

require "spec_helper"

RSpec.describe "Font Awesome integration" do
  it "globally appends font awesome paths into Sprockets environment" do
    Jekyll::Assets::FontAwesome.bind
    start_site
    expect(@site.assets["font-awesome.css"].to_s).to match(/fa-github/)
  end
end
