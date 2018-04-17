# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
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

  describe "#initialize" do
    context "on Jekyll::Site" do
      it "sets sprockets" do
        expect(env.jekyll.sprockets).not_to be_nil
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
end
