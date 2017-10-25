# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require "rspec/helper"
describe Jekyll::Assets::Config do
  context do
    let(:val) { subject.new(hello: :world) }
    it "should merge configurations" do
      expect(val.values_at(:hello, :autowrite)).to(eq([
        :world, subject::DEVELOPMENT[:autowrite]
      ]))
    end
  end

  context do
    let(:val) { subject.new(sources: ["hello"]) }
    it "should merge sources" do
      expect(val[:sources].grep(/hello/).size).to(eq(1))
    end
  end
end
