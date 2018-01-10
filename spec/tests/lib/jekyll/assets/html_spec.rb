# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::HTML do
  class TestHTML1 < Jekyll::Assets::HTML
    content_types :hello
    def run
      nil
    end
  end

  #

  let :asset do
    out = env.find_asset!("img.png")
    allow(out).to receive(:content_type).and_return(:hello)
    out
  end

  #

  let :kwd do
    {
      asset: asset,
      ctx: Thief.ctx,
      args: {},
    }
  end

  #

  it do
    respond_to :doc
  end

  #

  describe ".build" do
    after do
      subject.build(**kwd)
    end

    #

    describe "#run" do
      it "gets messaged" do
        expect_any_instance_of(TestHTML1).to receive(:run)
      end
    end

    #

    it "sends a <Doc>" do
      expect(TestHTML1).to receive(:new).with(hash_including({
        doc: instance_of(Nokogiri::HTML::DocumentFragment),
      })).and_call_original
    end
  end

  #

  describe ".make_doc" do
    context "w/ wants_xml?" do
      let :asset do
        out = env.find_asset!("img.svg")
        allow(out).to receive(:content_type).and_return(:hello)
        out
      end

      #

      before do
        allow(TestHTML1).to receive(:wants_xml?)
          .and_return(true)
      end

      #

      it "returns XML <Doc>" do
        expect(subject.make_doc([TestHTML1], asset: asset)).to \
          be_a(Nokogiri::XML::Document)
      end
    end

    #

    context "w/out wants_xml?" do
      before do
        allow(TestHTML1).to receive(:wants_xml?)
          .and_return(false)
      end

      #

      it "returns HTML <Doc>" do
        expect(subject.make_doc([TestHTML1], asset: asset)).to \
          be_a(Nokogiri::HTML::DocumentFragment)
      end
    end
  end
end
