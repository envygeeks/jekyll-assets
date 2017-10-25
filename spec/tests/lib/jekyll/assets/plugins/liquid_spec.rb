# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require "rspec/helper"
describe "Plugins/Liquid" do
  let(:asset) { env.find_asset!("plugins/liquid.css") }
  it "should pre-process" do
    expect(asset.to_s).to(match("html{opacity:3}body{opacity:3}\n"))
  end
end
