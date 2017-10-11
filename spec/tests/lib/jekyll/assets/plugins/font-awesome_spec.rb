# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "Plugins/FontAwesome" do
  let(:asset) { env.manifest.find("plugins/fon-awesome.css").first }
  it "should import" do
    expect(asset.to_s).to(match(/^\.fa\{/))
  end
end
