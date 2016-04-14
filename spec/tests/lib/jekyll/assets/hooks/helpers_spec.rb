# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
describe "sprockets helpers" do
  let :env do
    Jekyll::Assets::Env.new(
      stub_jekyll_site
    )
  end

  #

  it "initializes the helpers" do
    Sprockets::Helpers.instance_methods.each do |method|
      expect(env.context_class.method_defined?(method)).to(
        be_truthy
      )
    end
  end

  #

  it "uses our digest" do
    expect(Sprockets::Helpers.digest).to eq(
      env.digest?
    )
  end

  #

  it "adds our prefix" do
    expect(Sprockets::Helpers.prefix).to eq(
      env.prefix_path
    )
  end
end
