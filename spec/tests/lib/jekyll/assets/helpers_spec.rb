# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Helpers do
  let(:asset) { environment.find_asset!("bundle.css") }
  let :path do
    jekyll.in_dest_dir("/assets")
  end

  subject do
    environment.context_class.new({
      name: asset.logical_path,
      filename: asset.filename,
      load_path: File.dirname(asset.filename),
      content_type: asset.content_type,
      metadata: asset.metadata,
      environment: environment.cached,
    })
  end

  describe "#asset_path" do
    context do
      before { stub_asset_config strict: true }
      let(:error) { Sprockets::FileNotFound }
      it "should raise when an asset cannot be found" do
        expect { subject.asset_path("unknown") }.to(raise_error(error))
      end
    end

    context do
      let(:path) { environment.prefix_path(environment.find_asset("img").digest_path) }
      it "should return a path" do
        expect(subject.asset_path("img")).to(eq(path))
      end
    end
  end

  describe "#asset_url" do
    it "should wrap the path in url()" do
      expect(subject.asset_url("img.png")).to(start_with("url("))
    end
  end
end
