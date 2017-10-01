# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Config do
  let(:site) { stub_jekyll_site }
  subject do
    described_class
  end

  it "should merge configurations" do
    val = subject.new({ :hello => :world })
    expect(val.values_at(:hello, :autowrite)).to(eq([
      :world, subject::DEVELOPMENT[
        :autowrite
      ]
    ]))
  end

  #

  it "should merge sources" do
    val = subject.new({ :sources => [ "hello" ]})
    expect(val[:sources].grep(/hello/).size).
      to(eq(1))
  end
end
