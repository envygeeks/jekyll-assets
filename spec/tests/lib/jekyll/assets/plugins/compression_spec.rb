# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "Plugins/Compression" do
  describe "CSS" do
    let(:asset) { environment.find_asset!("plugins/compression.css") }
    it "should compress" do
      result = "body{color:#fff}\n"
      expect(asset.to_s).to(eq(result))
    end
  end

  describe "JS" do
    let(:asset) { environment.find_asset!("plugins/compression.js") }
    it "should compress" do
      result = "!function(){console.log(\"hello\")}();"
      expect(asset.to_s).to(eq(result))
    end
  end
end
