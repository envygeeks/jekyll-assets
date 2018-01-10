# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Config do
  it "merges" do
    expect(subject.new(hello: :world).values_at(:hello, :autowrite))
      .to eq([:world, subject::DEVELOPMENT[:autowrite]])
  end

  #

  it "merges sources" do
    expect(subject.new(sources: ["hello"])[:sources]
      .grep(%r!hello!).size).to eq(1)
  end
end
