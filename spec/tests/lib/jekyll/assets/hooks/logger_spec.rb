# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

require "rspec/helper"

describe "logger hook" do
  let(:env) {  Jekyll::Assets::Env.new(stub_jekyll_site) }
  it "sets the sprockets logger to use Jekyll's logger" do
    expect(env.logger).to be_kind_of \
      Jekyll::Assets::Logger
  end
end
