# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
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
    it "returns a pat" do
      expect(subject.asset_path("img")).to eq(env.prefix_url(env
        .find_asset("img").digest_path))
    end

    #

    it "supports proxies" do
      asset = subject.asset_path("img.png @magick:double")
      s1 = FastImage.new(env.find_asset!("img.png").filename)
      s2 = FastImage.new(jekyll.in_dest_dir(asset))

      expect(asset).not_to be_empty
      expect(s1.size[0] * 2).to eq(s2.size[0])
      expect(s1.size[1] * 2).to eq(s2.size[1])
    end
  end

  #

  describe "#asset_url" do
    it "wraps inside of url()" do
      expect(subject.asset_url("img.png")).to start_with("url(")
    end
  end
end
