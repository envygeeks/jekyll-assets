# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

require "rspec/helper"
describe "Plugins/Bootstrap" do
  let(:asset) { env.find_asset!("plugins/botstrap.css") }
  it "should require bootstrap" do
    expect(asset.to_s).not_to(be_empty)
  end
end
