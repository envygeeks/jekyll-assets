# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Helpers do
  let(:env) { Jekyll::Assets::Env.new(jekyll) }
  let(:asset) { env.manifest.find("bundle.css").first }
  let(:path) { jekyll.in_dest_dir("/assets") }
  let(:jekyll) { stub_jekyll_site }

  #

  subject do
    env.context_class.new({
      name: asset.logical_path,
      filename: asset.filename,
      load_path: File.dirname(asset.filename),
      content_type: asset.content_type,
      metadata: asset.metadata,
      environment: env.cached,
    })
  end

  #

  describe "#asset_path" do
    it "should raise when an asset cannot be found" do
      expect { subject.asset_path("unknown") }.to(raise_error(
        described_class::AssetNotFound))
    end

    it "should return a path" do
      expect(subject.asset_path("ubuntu")).to(eq(
        env.prefix_path(env.find_asset("ubuntu").
          digest_path)))
    end
  end

  #

  describe "#asset_url" do
    it "should wrap the path in url()" do
      expect(subject.asset_url("ubuntu")).to(start_with("url("))
    end
  end
end
