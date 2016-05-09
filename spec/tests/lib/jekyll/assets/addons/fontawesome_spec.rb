# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
describe "font-awesome" do
  let :env do
    Jekyll::Assets::Env.new(
      stub_jekyll_site
    )
  end

  #

  it "makes font-awesome available" do
    expect(env.find_asset("fa").to_s).to match(
      %r!fa-.+:before\s+{!
    )
  end
end
