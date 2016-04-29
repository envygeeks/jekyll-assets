# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
describe "Compiling Less" do
  let :env do
    Jekyll::Assets::Env.new(
      stub_jekyll_site
    )
  end

  #

  it "should compile less files" do
    matcher = /^body {\n\s+background-image: url\(\/assets\/context.jpg\);\s+\}/m
    expect(env.find_asset("less").to_s).to match(
      matcher
    )
  end
end
