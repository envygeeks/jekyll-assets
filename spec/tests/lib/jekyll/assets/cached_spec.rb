# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Cached do
  let(:env) { Jekyll::Assets::Env.new(site) }
  before(:each, :process => true) { site.process }
  let(:path) { site.in_dest_dir("/assets") }
  let(:site) { stub_jekyll_site }
  subject { env }

  it { respond_to(:manifest) }
  it { respond_to(:asset_config) }
  it { respond_to(:uncached) }
  it { respond_to(:jekyll) }

  describe "#uncached" do
    it "should be the environment" do
      expect(env.cached.uncached).to(eq(env))
    end
  end
end
