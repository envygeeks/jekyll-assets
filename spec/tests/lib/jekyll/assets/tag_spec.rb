# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Tag do
  [:asset, :css, :js, :img].each do |k|
    context k.to_s, :render => true do
      let :page do
        jekyll.pages.find do |v|
          v.path == "tag/#{k}.html"
        end
      end

      it "should render" do
        expect(page.to_s.strip).not_to(be_empty)
      end
    end
  end

  context nil, :render => true do
    let :page do
      jekyll.pages.find do |v|
        v.path == "tag/attr.html"
      end
    end

    subject do
      fragment(page.to_s.strip)
    end

    it "should render custom attributes" do
      html = subject.children.first
      expect(html.attributes["myattr"].to_s).to(eq("val"))
      expect(html.attributes).to(have_key("myattr"))
    end

    context "when given @path" do
      it "should just output the path" do
        page = jekyll.pages.find { |v| v.path == "tag/path.html" }
        path = environment.prefix_path(environment.find_asset("bundle.css").digest_path)
        expect(page.to_s.strip).to(eq(path))
      end
    end
  end
end
