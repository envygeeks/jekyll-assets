# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Hook do
  it "should store hooks on POINTS" do
    expect(subject::POINTS).to(be_a(Hash))
  end

  describe "#add_point" do
    it "should raise if given an invalid point" do
      expect { subject.add_point(:good1, :good2, :bad1) }.
        to(raise_error(ArgumentError))
    end

    context do
      before do
        stub_const("Jekyll::Assets::Hook::POINTS", {
          #
        })
      end

      it "should add the point" do
        subject.add_point(:good1, :good2)
        expect(subject::POINTS[:good1]).to(have_key(:good2))
        expect(subject::POINTS).to(have_key(:good1))
      end
    end
  end

  describe "#get_point" do
    context "when a point is invalid" do
      it "should raise" do
        expect { subject.get_point(:good1, :good2, :bad1) }.
          to(raise_error(ArgumentError))
      end
    end

    context "when a point doesn't exist" do
      it "should raise" do
        expect { subject.get_point(:non, :existant) }.
          to(raise_error(ArgumentError))
      end
    end

    it "should return the hooks" do
      expect(subject.get_point(:env, :init)).to(be_a(Array))
    end
  end
end
