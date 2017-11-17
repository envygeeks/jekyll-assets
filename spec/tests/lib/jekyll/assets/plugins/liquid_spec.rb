# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "Plugins/Liquid" do
  let(:asset) do
    env.find_asset!("plugins/liquid.css")
  end

  #

  it "should pre-process" do
    expect(asset.to_s.gsub(%r!\s+|\n+|;!, "").strip).to \
      match("html{opacity:3}body{opacity:3}")
  end
end
