# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Sprockets::Context do
  let(:asset) do
    env.find_asset!("bundle.css")
  end

  #

  subject do
    env.context_class.new({
      filename: asset.filename,
      name: asset.logical_path,
      load_path: File.dirname(asset.filename),
      content_type: asset.content_type,
      metadata: asset.metadata,
      environment: env.cached,
    })
  end

  #

  describe "#asset_path" do
    it "returns" do
      expect(subject.asset_path("img")).to eq(env.prefix_url(env
        .find_asset("img").digest_path))
    end

    #

    it "proxies" do
      cls = Jekyll::Assets::Plugins::MiniMagick
      expect_any_instance_of(cls).to receive(:process)
      subject.asset_path("img.png @magick:double")
    end
  end
end
