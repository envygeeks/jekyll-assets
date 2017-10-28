# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Env do
  subject do
    env
  end

  #

  it { respond_to :manifest }
  it { respond_to :asset_config }
  it { respond_to :jekyll }

  #

  describe "#cache" do
    before do
      subject.instance_variable_set(:@cache, nil)
    end

    #

    context "asset_config[:caching][:type]" do
      context "w/ nil" do
        before do
          stub_asset_config({
            caching: {
              type: nil,
            },
          })
        end

        #

        it "defaults" do
          expect(subject.cache).to be_a(Sprockets::Cache)
        end
      end

      #

      context "w/ empty" do
        before do
          stub_asset_config({
            caching: {
              type: "",
            },
          })
        end

        #

        it "defaults" do
          expect(subject.cache).to be_a(Sprockets::Cache)
        end
      end
    end
  end

  #

  describe "#to_liquid_payload" do
    it "returns Hash<String,Drop>" do
      subject.to_liquid_payload.each_value do |v|
        expect(v).to be_a(Jekyll::Assets::Drop)
      end
    end

    #

    it "is a Hash" do
      expect(subject.to_liquid_payload).to be_a(Hash)
    end
  end

  #

  describe "#excludes!" do
    it "adds" do
      expect(jekyll.config["exclude"]).to include(env
        .asset_config["sources"].first)
    end
  end

  #

  describe "#enable_compression!" do
    context "w/ asset_config[:compression] = true" do
      it "enables" do
        expect(env.js_compressor).not_to be_nil
      end
    end
  end
end
