# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Liquid::Drop do
  subject do
    described_class.new("ubuntu.png", {
      jekyll: jekyll
    })
  end

  #

  it { respond_to :height }
  it { respond_to :basename }
  it { respond_to :digest_path }
  it { respond_to :logical_path }
  it { respond_to :content_type }
  it { respond_to :integrity }
  it { respond_to :filename }
  it { respond_to :width }

  #

  describe "#dimensions" do
    it "should return a hash" do
      expect(subject.dimensions).to(be_a(Hash))
    end
  end
end
