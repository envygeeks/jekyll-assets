# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Hook do
  it do
    respond_to :points
  end

  #

  describe "#add_point" do
    context "w/ invalid point" do
      it "raises" do
        expect { subject.add_point(:good1, :good2, :bad1) }
          .to raise_error(ArgumentError)
      end
    end

    #

    it "adds" do
      subject.add_point(:good1, :good2)
      var = subject.instance_variable_get(:@points)
      expect(var[:good1]).to have_key(:good2)
    end
  end

  #

  describe "#get_point" do
    context "when a point is invalid" do
      it "raises" do
        expect { subject.get_point(:good1, :good2, :bad1) }
          .to raise_error(ArgumentError)
      end
    end

    #

    context "when a point doesn't exist" do
      it "raises" do
        expect { subject.get_point(:non, :existant) }
          .to raise_error(ArgumentError)
      end
    end

    #

    it "returns Array<Proc>" do
      expect(subject.get_point(:env, :before_init)).to be_a(Array)
    end
  end
end
