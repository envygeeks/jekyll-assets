# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Extensible do
  it { respond_to :args }
  it { respond_to :jekyll }
  it { respond_to :asset }
  it { respond_to :env }

  #

  TestExtensible1 = Class.new(Jekyll::Assets::Extensible)
  TestExtensible2 = Class.new(TestExtensible1)
  TestExtensible1.content_types :hello
  TestExtensible1.arg_keys :hello

  #

  describe ".inherited" do
    it "returns Array<Object>" do
      expect(TestExtensible1.inherited).not_to be_empty
    end
  end

  #

  describe ".requirements" do
    it "returns Hash<Symbol,Object>" do
      expect(TestExtensible1.requirements).to be_a(Hash)
    end
  end

  #

  describe ".for?, .for_args, .for_type?" do
    context "w/ valid kwds" do
      it "true" do
        args = { hello: :world }
        kwds = { type: :hello, args: args }
        expect(TestExtensible1.for?(**kwds))
          .to eq(true)
      end
    end

    #

    context "w/ invalid kwds" do
      it "false" do
        args = { world: :hello }
        kwds = { type: :hello, args: args }
        expect(TestExtensible1.for?(**kwds))
          .to eq(false)
      end
    end
  end
end
