# rubocop:disable Naming/FileName
# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "Plugins/FontAwesome" do
  let(:asset) { env.find_asset!("plugins/fon-awesome.css") }
  it "should import" do
    expect(asset.to_s).to(match(%r!^\.fa\s*\{!))
  end
end
