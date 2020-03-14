# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

require "rspec/helper"
describe "Plugins/Alternates" do
  let(:asset) { env.find_asset!("plugins/alternates.css") }
  it "should add /* @alternate */" do
    expect(asset.to_s).to match(%r!/\* @alternate \*/!)
  end
end
