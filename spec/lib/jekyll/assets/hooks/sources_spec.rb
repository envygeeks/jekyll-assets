# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "asset sources" do
  let( :env) { Jekyll::Assets::Env.new(site) }
  let(:site) { stub_jekyll_site }

  it "allows user to set their own asset locations" do
    stub_asset_config site, "sources" => %W(_foo/bar)
    results = env.paths.grep(/\A#{Regexp.union(site.in_source_dir)}/)
    expect(results).to include site.in_source_dir("_foo/bar")
    expect(results.size).to eq 1
  end
end
