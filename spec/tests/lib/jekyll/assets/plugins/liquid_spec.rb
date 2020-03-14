# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

require "rspec/helper"
describe "Plugins/Liquid" do
  context "w/ .svg.liquid" do
    let(:asset) do
      env.find_asset!("plugins/liquid/basic1.svg")
    end

    #

    it "works" do
      expect(asset.to_s.strip).to match(%q!<svg height="3"></svg>!)
    end
  end

  context "w/ .liquid.svg" do
    let(:asset) do
      env.find_asset!("plugins/liquid/basic2.svg")
    end

    #

    it "works" do
      expect(asset.to_s.strip).to match(%q!<svg height="3"></svg>!)
    end
  end

  context "w/ .scss.liquid" do
    let(:asset) do
      env.find_asset!("plugins/liquid/basic1.css")
    end

    #

    it "works" do
      expect(asset.to_s.gsub(%r!\s+|\n+|;!, "").strip).to \
        match("html{opacity:3}")
    end
  end

  context "w/ .liquid.scss" do
    let(:asset) do
      env.find_asset!("plugins/liquid/basic2.css")
    end

    #

    it "works" do
      expect(asset.to_s.gsub(%r!\s+|\n+|;!, "").strip).to \
        match("html{opacity:3}")
    end
  end

  #

  context "inception/complex" do
    let :asset do
      env.find_asset!("plugins/liquid/complex.css")
    end

    #

    it "works" do
      expect(asset.to_s).to match(%r!hello:\s*"/assets/!)
      expect(asset.to_s).to match(%r!background:\s*url\("/assets/!)
      expect(asset.to_s).to match(%r!world:\s*"&amp;"!)
    end
  end
end
