# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "rspec/helper"
describe Jekyll::Assets::Liquid::Tag::ProxiedAsset do
  let :instance do
    subject.new(
      @asset, @tag.args, @env, @tag
    )
  end

  #

  subject do
    described_class
  end

  #

  before :all do
    @site  = stub_jekyll_site
    @env   = Jekyll::Assets::Env.new(@site)
    @env.liquid_proxies.add :test, :img, "@hello" do
      def initialize(asset, opts, args)
        @path  = asset.filename
        @opts  = opts
        @asset = asset
        @args = args
      end

      def process
        File.write(@path, "hello")
      end
    end

    @asset = @env.find_asset("ruby.png")
    @tag   = Jekyll::Assets::Liquid::Tag.send(
      :new, "img", "ruby.png test:hello", []
    )
  end

  #

  context do
    before do
      @asset = @env.find_asset("subdir/ubuntu")
      @tag   = Jekyll::Assets::Liquid::Tag.new(
        "img", "subdir/ubuntu.png test:hello", []
      )
    end

    #

    it "keeps the users sub-folders" do
      expect(instance.logical_path).to start_with(
        "subdir/"
      )
    end

    #

    context do
      before do
        @proxied_asset = subject.new(@asset, @tag.args, @env, @tag)
        @tag.render(OpenStruct.new(:registers => { :site => @site }))
        @env.instance_variable_set(:@used, Set.new([@proxied_asset]))
        allow(@site).to receive(:sprockets) { @env }
        @site.process
      end

      #

      it "writes the sub-folders" do
        expect(Pathname.new(@site.in_dest_dir("assets", @proxied_asset.digest_path))).to(
          exist
        )
      end
    end
  end

  #

  it "runs the proxy" do
    @tag.render(OpenStruct.new(:registers => { :site => @site }))
    expect(File.read(Dir.glob(@env.in_cache_dir("ruby-*.png")).first)).to(
      eq "hello"
    )
  end

  #

  it "sets cached = false if the asset doesn't exist" do
    Dir[@env.in_cache_dir("ruby-*.png")].map(&FileUtils.method(:rm))
    expect(instance.cached?).to(
      be false
    )
  end

  #

  it "sets cached = true if the asset exists" do
    expect(instance.cached?).to be(
      true
    )
  end

  #

  it "provides access to the assets source" do
    expect(instance.source).not_to(
      be_empty
    )
  end

  #

  it "provides a digest, and bases it on the arguments" do
    expect(instance.digest).not_to be_empty
    expect(instance.digest).to eq Digest::SHA2.hexdigest(
      @tag.args.proxies.to_s
    )
  end

  #

  it "always digest the path to ensure uniqness" do
    expect(instance.logical_path).to eq(
      instance.digest_path
    )
  end

  #

  it "caches the file inside of the asset cache directory" do
    expect(Pathname.new(@env.in_cache_dir(instance.logical_path))).to(
      exist
    )
  end
end
