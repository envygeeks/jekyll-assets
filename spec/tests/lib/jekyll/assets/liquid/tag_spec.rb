# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Liquid::Tag do
  context do
    it "should log errors" do
      expect(env.logger).to(receive(:error))
    end

    after :each do
      jekyll.reset
      jekyll.process
      jekyll.render
    end
  end

  #

  [:asset, :css, :js, :img].each do |k|
    context k.to_s, :render => true do
      let :page do
        jekyll.pages.find do |v|
          v.path == "tag/#{k}.html"
        end
      end

      #

      it "should render" do
        require"pry"
        Pry.output = STDOUT
        binding.pry
        expect(page.to_s.strip).
          not_to(be_empty)
      end

      #

      it "should output the right HTML" do
        frag = fragment(page.to_s.strip)
        expect(frag.children.first.name).to(eq(
          subject::HTML[k].to_s))
      end
    end
  end

  #

  context nil, :render => true do
    it "should render custom attributes" do
      page = jekyll.pages.find { |v| v.path == "tag/attr.html" }
      frag = fragment(page.to_s.strip)
      html = frag.children.first

      expect(html.attributes).to(have_key("myattr"))
      expect(html.attributes["myattr"].to_s).
        to(eq("val"))
    end

    context "when given @path" do
      it "should just output the path" do
        page = jekyll.pages.find { |v| v.path == "tag/path.html" }
        expect(page.to_s.strip).to(eq(env.prefix_path(env.
          find_asset("bundle.css").digest_path)))
      end
    end
  end
end
