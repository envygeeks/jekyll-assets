# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

require "rspec/helper"
describe "Plugins/Optim" do
  let :asset do
    env.find_asset!("img.png")
  end

  describe "@preset" do
    let :page do
      jekyll.pages.find do |v|
        v.path == "plugins/optim.html"
      end
    end

    it "works" do
      file = fragment(page.to_s.strip).children.first
      file = Pathutil.new(env.jekyll.in_dest_dir(file.attr(:src)))
      asst = Pathutil.new(asset.filename)
      expect(file.size).to be < asst.size
    end
  end
end
