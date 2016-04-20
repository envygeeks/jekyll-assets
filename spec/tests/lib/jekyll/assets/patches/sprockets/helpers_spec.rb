# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
describe Sprockets::Helpers do
  let :env do
    Jekyll::Assets::Env.new(
      stub_jekyll_site
    )
  end

  #

  before do
    @old_cached = env.instance_variable_get(:@cached)
    @old_cache  = env.cached

    env.instance_variable_set(:@cached, nil)
    env.cache = Sprockets::Cache::FileStore.new(
      Pathutil.tmpdir
    )
  end

  #

  after do
    env.cache = @old_cache
    env.instance_variable_set(:@cached,
      @old_cached
    )
  end

  #

  it "patches asset context so we can track used assets in assets" do
    expect(env.context_class.method_defined?(:_old_ap)).to(
      be true
    )
  end

  #

  it "adds the asset to the env#used set" do
    env.find_asset "context", :accept => "text/css"
    expect(env.used.first.pathname.fnmatch?("*/context.jpg")).to eq true
    expect(env.used.size).to eq 1
  end

  #

  it "should write the asset when write_all is done" do
    env.find_asset "context", :accept => "text/css"; env.write_all
    expect(Pathutil.new(env.jekyll.in_dest_dir).join("assets/context.jpg")).to(
      exist
    )
  end
end
