# Frozen-string-literal: true
# Copyright: 2019 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "Plugins/Vips" do
  let :asset do
    env.find_asset!("img.png")
  end

  describe "format" do
    let :page do
      jekyll.pages.find do |v|
        v.path == "plugins/vips/format.html"
      end
    end

    it "should be jpeg" do
      frag = fragment(page.to_s).children.first
      t = FastImage.type(env.jekyll.in_dest_dir(frag.attr("src")))
      expect(t).to(eq(:jpeg))
    end
  end

  describe "compress" do
    let :page do
      jekyll.pages.find do |v|
        v.path == "plugins/vips/compress.html"
      end
    end

    it "should be smaller" do
      frag = fragment(page.to_s).children.first
      file = Pathutil.new(env.jekyll.in_dest_dir(frag.attr(:src)))
      asst = Pathutil.new(asset.filename)
      expect(file.size).to be < asst.size
    end
  end

  describe "resize" do
    let :page do
      jekyll.pages.find do |v|
        v.path == "plugins/vips/resize.html"
      end
    end

    it "should be 100x100" do
      frag = fragment(page.to_s).children.first
      w, h = FastImage.size(env.jekyll.in_dest_dir(frag.attr("src")))
      expect(w).to(eq(100))
      expect(h).to(eq(100))
    end
  end

  describe "double" do
    let :page do
      jekyll.pages.find do |v|
        v.path == "plugins/vips/double.html"
      end
    end

    it "should be doubled" do
      frag = fragment(page.to_s).children.first
      w1, h1 = FastImage.size(asset.filename)
      w2, h2 = FastImage.size(env.jekyll.in_dest_dir(frag.attr("src")))
      expect(w2).to(eq(w1 * 2))
      expect(h2).to(eq(h1 * 2))
    end
  end

  describe "half" do
    let :page do
      jekyll.pages.find do |v|
        v.path == "plugins/vips/half.html"
      end
    end

    it "should be halved" do
      frag = fragment(page.to_s).children.first
      w1, h1 = FastImage.size(asset.filename)
      w2, h2 = FastImage.size(env.jekyll.in_dest_dir(frag.attr("src")))
      expect(w2).to(eq(w1 * 0.5))
      expect(h2).to(eq(h1 * 0.5))
    end
  end
end
