# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Helpers do
  let(:asset) { env.manifest.find("bundle.css").first }
  let :path do
    jekyll.in_dest_dir("/assets")
  end

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

  describe "#asset_path" do
    context do
      before { stub_asset_config strict: true }
      let(:error) { Jekyll::Assets::Errors::AssetNotFound }
      it "should raise when an asset cannot be found" do
        expect { subject.asset_path("unknown") }.to(raise_error(error))
      end
    end

    context do
      let(:path) { env.prefix_path(env.find_asset("img").digest_path) }
      it "should return a path" do
        expect(subject.asset_path("img")).to(eq(path))
      end
    end
  end

  describe "#asset_url" do
    it "should wrap the path in url()" do
      expect(subject.asset_url("ubuntu")).to(start_with("url("))
    end
  end
end
