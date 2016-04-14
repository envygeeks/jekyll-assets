# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
describe "bootstrap" do
  let :env do
    Jekyll::Assets::Env.new(
      stub_jekyll_site
    )
  end

  #

  it "adds it to the asset paths" do
    expect(env.paths.grep(/bootstrap-sass-.*\/assets/).any?).to(
      be_truthy
    )
  end

  #

  it "allows you to import" do
    expect(env.find_asset("strapboot").to_s).not_to eq(
      "@import \"bootstrap\"\n"
    )
  end
end
