# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Helpers do
  let :site do
    stub_jekyll_site
  end

  #

  let :asset do
    site.sprockets.find_asset(
      "ruby.png"
    )
  end

  #

  subject do
    site.sprockets.context_class.new({
      :environment => site.sprockets,
      :manifest => site.sprockets.manifest,
      :filename => asset.pathname.to_s,
      :metadata => asset.metadata
    })
  end

  #

  describe "#asset_path" do
    it "should prefix the path" do
      expect(subject.asset_path("ruby.png")).to eq(
        site.sprockets.prefix_path(
          "ruby.png"
        )
      )
    end

    #

    context "when the user enables digesting" do
      before do
        allow(site.sprockets).to receive(:digest?).and_return(
          true
        )
      end

      #

      it "should add the digested path" do
        expect(subject.asset_path("ruby.png")).to eq(
          site.sprockets.prefix_path(
            asset.digest_path
          )
        )
      end
    end
  end

  #

  describe "#asset_url" do
    it "should wrap the path around url()" do
      expect(subject.asset_url("ruby.png")).to eq(
        "url(#{site.sprockets.prefix_path("ruby.png")})"
      )
    end
  end
end
