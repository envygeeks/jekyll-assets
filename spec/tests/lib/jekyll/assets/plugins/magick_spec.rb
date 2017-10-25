# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

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
      w1, h1 = FastImage.size(env.jekyll.in_dest_dir(frag.attr("src")))
      w2, h2 = FastImage.size(asset.filename)
      expect(w1).to(eq(w2 * 2))
      expect(h1).to(eq(h2 * 2))
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
      w1, h1 = FastImage.size(env.jekyll.in_dest_dir(frag.attr("src")))
      w2, h2 = FastImage.size(asset.filename)
      expect(w1).to(eq(w2 / 2))
      expect(h1).to(eq(h2 / 2))
    end
  end
end
