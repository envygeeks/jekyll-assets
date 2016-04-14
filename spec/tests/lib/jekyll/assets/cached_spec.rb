# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

require "rspec/helper"

describe Jekyll::Assets::Cached do
  let(:cached) { Jekyll::Assets::Cached.new(Jekyll::Assets::Env.new(site)) }
  let(  :site) { stub_jekyll_site }

  it "adds the Jekyll instance" do
    expect(cached).to respond_to :jekyll
    expect(cached.jekyll).to be_kind_of Jekyll::Site
  end

  it "adds the parent the *non-cached* instance" do
    expect(cached).to respond_to :parent
    expect(cached.parent).to be_kind_of Jekyll::Assets::Env
  end
end
