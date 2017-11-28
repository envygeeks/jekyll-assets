# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "Plugins/Searcher" do
  let :asset do
    env.find_asset!("img.png")
  end

  describe "w/ <img asset>" do
    let :page do
      jekyll.pages.find do |v|
        v.path == "plugins/searcher.html"
      end
    end

    it "works" do
      file = fragment(page.output.strip)
      expect(file.search("img").size).to eq(3)
      file.search("img").each do |v|
        expect(v[:src]).to match(%r!^/assets/!)
      end
    end

    context "w/ lowercase doctype" do
      let :page do
        jekyll.pages.find do |v|
          v.path == "plugins/searcher_lc.html"
        end
      end

      it "works" do
        file = fragment(page.output.strip)
        expect(file.search("img").size).to eq(3)
        file.search("img").each do |v|
          expect(v[:src]).to match(%r!^/assets/!)
        end
      end
    end
  end
end
