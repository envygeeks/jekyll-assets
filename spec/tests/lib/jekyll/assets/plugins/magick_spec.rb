# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "Plugins/Magick" do
  let :asset do
    env.find_asset!("img.png")
  end

  describe "double" do
    let :page do
      jekyll.pages.find do |v|
        v.path == "plugins/magick/double.html"
      end
    end

    it "should double the size" do
      frag = fragment(page.to_s).children.first
      width, height = frag.attr("width"), frag.attr("height")
      dim = FastImage.new(asset.filename)

      expect( width.to_i).to(eq(dim.size.first * 2))
      expect(height.to_i).to(eq(dim.size.last  * 2))
    end
  end

  describe "half" do
    let :page do
      jekyll.pages.find do |v|
        v.path == "plugins/magick/half.html"
      end
    end

    it "should half the size" do
      frag = fragment(page.to_s).children.first
      width, height = frag.attr("width"), frag.attr("height")
      dim = FastImage.new(asset.filename)

      expect( width.to_i).to(eq(dim.size.first / 2))
      expect(height.to_i).to(eq(dim.size.last  / 2))
    end
  end
end
