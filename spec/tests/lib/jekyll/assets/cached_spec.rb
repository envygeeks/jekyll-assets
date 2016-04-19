# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
describe Jekyll::Assets::Cached do
  let :cached do
    Jekyll::Assets::Cached.new(Jekyll::Assets::Env.new(
      site
    ))
  end

  #

  let :site do
    stub_jekyll_site
  end

  #

  it "adds the Jekyll instance" do
    expect(cached).to respond_to :jekyll
    expect(cached.jekyll).to be_kind_of(
      Jekyll::Site
    )
  end

  #

  it "adds the parent the *non-cached* instance" do
    expect(cached).to respond_to :parent
    expect(cached.parent).to be_kind_of(
      Jekyll::Assets::Env
    )
  end

  #

  it "caches resolved paths" do
    first = cached.resolve("ruby.png")
    second = cached.resolve("ruby.png")

    expect(first).to match /assets\/img\/ruby\.png/
    expect(first).to eq second

    expect(first.object_id).to eq second.object_id
  end
end
