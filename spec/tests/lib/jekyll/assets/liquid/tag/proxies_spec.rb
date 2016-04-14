# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
describe Jekyll::Assets::Liquid::Tag::Proxies do
  subject do
    described_class
  end

  #

  before :each do
    allow(subject).to receive(:all) do
      @_all ||= Set.new
    end

    stub_proxy
  end

  #

  def stub_proxy
    subject.add_by_class :internal, :my, :all, ["accept"]
    subject.add_by_class :internal, :me, :img, ["hellos"]
  end

  #

  context "adds both string and symbol types for" do
    specify "name" do
      result = subject.get(:me).first[:name]
      expect(result).to include "me"
      expect(result).to include :me
    end

    #

    specify "args" do
      result = subject.get(:my).first[:args]
      expect(result).to include "accept"
      expect(result).to include :accept
    end

    #

    specify "tags" do
      result = subject.get(:me).first[:tags]
      expect(result).to include "img"
      expect(result).to include :img
    end
  end

  #

  context "can get proxies based on" do
    specify "name" do
      expect(subject.get(:me).size).to eq 1
      expect(subject.get(:my).size).to eq 1
    end

    #

    specify "name, tag" do
      expect(subject.get(:me, :img ).size).to eq 1
      expect(subject.get(:me, "img").size).to eq 1
    end

    #

    specify "name, tag, arg" do
      expect(subject.get(:me, :img,  :hellos ).size).to eq 1
      expect(subject.get(:me, "img", "hellos").size).to eq 1
    end
  end
end
