# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Processors::Liquid do
  context "when the extension is .liquid" do
    let(:asset) { env.find_asset("liquid") }
    let(:env) { Jekyll::Assets::Env.new(stub_jekyll_site) }
    let(:source) { asset.to_s }

    it "lets the user use Liquid" do
      expect(source).not_to match(/\{{2}\s*site\.background_image\s*\}{2}/)
      expect(source).to match(/background:\s*url\("\/assets\/ruby\.png"\)/)
    end

    it "provides the right extension" do
      expect(asset.logical_path).to eq "liquid.css"
    end
  end

  context "when the extension is not liquid" do
    context "and liquid is disabled" do
      let(:asset) { env.find_asset("noliquid") }
      let(:env) { Jekyll::Assets::Env.new(stub_jekyll_site) }
      let(:source) { asset.to_s }

      it "should not process the liquid" do
        expect(source).to eq ".background {\n  background: " \
          "url(\"{{ site.background_image }}\"); }\n"
      end
    end

    context "and liquid is enabled" do
      let(:asset) { env.find_asset("otherliquid") }
      let(:env) { Jekyll::Assets::Env.new(stub_jekyll_site("assets" => { "features" => { "liquid" => true }})) }
      let(:source) { asset.to_s }

      it "should not process the liquid" do
        expect(source).not_to match(/\{{2}\s*site\.background_image\s*\}{2}/)
        expect(source).to match(/background:\s*url\("\/assets\/ruby\.png"\)/)
       end
    end
  end

  context "when sprockets requires a liquid file" do
    let(:asset) { env.find_asset("index") }
    let(:env) { Jekyll::Assets::Env.new(stub_jekyll_site) }
    let(:source) { asset.to_s }

    it "lets the user use Liquid" do
      expect(source).not_to match(/\{{2}\s*site\.background_image\s*\}{2}/)
      expect(source).to match(/background:\s*url\("\/assets\/ruby\.png"\)/)
    end

    it "provides the right extension" do
      expect(asset.logical_path).to eq "index.css"
    end
  end
end
