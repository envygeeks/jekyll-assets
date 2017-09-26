# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "asset caching" do
  let :env do
    Jekyll::Assets::Env.new(
      stub_jekyll_site
    )
  end

  #

  it "sets up a Sprockets FileStore cache for speed" do
    expect(env.cache.instance_variable_get(:@cache_wrapper).cache).to(
      be_kind_of Sprockets::Cache::FileStore
    )
  end

  #

  context "with cache_type set to memory" do
    let :env do
      Jekyll::Assets::Env.new(stub_jekyll_site("assets" => {
        "cache_type" => "memory"
      }))
    end

    #

    it "should setup MemoryStore cache" do
      expect(env.cache.instance_variable_get(:@cache_wrapper).cache).to(
        be_kind_of Sprockets::Cache::MemoryStore
      )
    end
  end

  #

  context "with cache set to false" do
    let :env do
      Jekyll::Assets::Env.new(stub_jekyll_site("assets" => {
        "cache" => false
      }))
    end

    #

    it "should setup a null cache" do
      expect(env.cache.instance_variable_get(:@cache_wrapper).cache).to(
        be_kind_of Sprockets::Cache::NullStore
      )
    end
  end
end
