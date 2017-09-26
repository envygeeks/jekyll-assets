# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "css auto-prefixing" do
  let :env do
    Jekyll::Assets::Env.new(
      stub_jekyll_site
    )
  end

  #

  it "prefixes css" do
    result = env.find_asset("prefix.css").to_s
    expect(result).to match %r!-webkit-(?:order|box-ordinal-group):!
    expect(result).to match %r!-ms-flex-order:!
  end
end
