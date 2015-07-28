require "rspec/helper"

describe Jekyll::Assets::Tag::Proxies do
  let(:klass) { described_class }
  before :each do
    allow(klass).to receive(:all) do
      @_all ||= Set.new
    end

    stub_proxy
  end

  def stub_proxy
    klass.add :internal, :my, :all, ["accept"]
    klass.add :internal, :me, :img, ["hellos"]
  end

  context "adds both string and symbol types for" do
    specify "name" do
      result = klass.get(:me).first[:name]
      expect(result).to include "me"
      expect(result).to include :me
    end

    specify "args" do
      result = klass.get(:my).first[:args]
      expect(result).to include "accept"
      expect(result).to include :accept
    end

    specify "tags" do
      result = klass.get(:me).first[:tags]
      expect(result).to include "img"
      expect(result).to include :img
    end
  end

  context "can get proxies based on" do
    specify "name" do
      expect(klass.get(:me).size).to eq 1
      expect(klass.get(:my).size).to eq 1
    end

    specify "name, tag" do
      expect(klass.get(:me, :img ).size).to eq 1
      expect(klass.get(:me, "img").size).to eq 1
    end

    specify "name, tag, arg" do
      expect(klass.get(:me, :img,  :hellos ).size).to eq 1
      expect(klass.get(:me, "img", "hellos").size).to eq 1
    end
  end
end
