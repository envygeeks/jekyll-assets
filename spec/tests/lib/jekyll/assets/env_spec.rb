# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Env do
  let(:env) { Jekyll::Assets::Env.new(site) }
  before(:each, :process => true) { site.process }
  let(:path) { site.in_dest_dir("/assets") }
  let(:site) { stub_jekyll_site }
  subject { env }

  #

  describe "#asset_config" do
    it "should merge defaults into user config" do
      stub_asset_config({ "hello" => "world" })
      expect(env.asset_config["hello"]).
        to(eq("world"))
    end

    #

    it "should merge sources" do
      stub_asset_config({ "sources" => [ "hello" ]})
      expect(env.asset_config["sources"].grep(/\/hello$/).size).to(
        eq(1))
    end
  end

  #

  describe "#manifest" do
    it "should put the path in Jekyll's dest dir" do
      expect(env.manifest.path).to(start_with(env.jekyll.source))
    end
  end

  #

  describe "#to_liquid_payload" do
    it "should build a list of liquid drops" do
      expect(env.to_liquid_payload).to(be_a(Hash))
      env.to_liquid_payload.each do |_, v|
        expect(v).to(be_a(Jekyll::Assets::Liquid::Drop))
      end
    end
  end

  #

  describe "#extra_assets" do
    it "should compile those extra assets" do
      stub_asset_config("assets" => ["ubuntu.png"])
      env.extra_assets

      asset = env.manifest.find("ubuntu.png").first
      expect(Pathutil.new(env.in_dest_dir(asset.digest_path
        ))).to(exist)
    end
  end

  #

  describe "#baseurl" do
    context "when cdn? = true" do
      context "and when cdn.baseurl = true" do
        it "should add baseurl" do
          env.instance_variable_set(:@baseurl, nil)
          stub_asset_config("cdn" => { "baseurl" => true })
          allow(env).to(receive(:cdn?).and_return(true))
          stub_jekyll_config("baseurl" => "hello")
          expect(env.baseurl).to(eq("hello"))
        end
      end

      #

      context "and when cdn.baseurl = false" do
        it "doesn't add baseurl" do
          env.instance_variable_set(:@baseurl, nil)
          allow(env).to(receive(:cdn?).and_return(true))
          stub_asset_config("cdn" => { "baseurl" => false })
          stub_jekyll_config("baseurl" => "hello")
          expect(env.baseurl).to(eq(""))
        end
      end

      #

      context "and when cdn.prefix = true" do
        it "should add the prefix" do
          env.instance_variable_set(:@baseurl, nil)
          stub_env_config("cdn" => { "prefix" => true })
          allow(env).to(receive(:cdn?).and_return(true))
          expect(env.baseurl).to(eq("/assets"))
        end
      end

      #

      context "and when cdn.prefix = false" do
        it "doesn't add prefix" do
          env.instance_variable_set(:@baseurl, nil)
          stub_env_config("cdn" => { "prefix" => false })
          allow(env).to(receive(:cdn?).and_return(true))
          expect(env.baseurl).to(eq(""))
        end
      end
    end
  end

  #

  describe "#prefix_path" do
    it "should add the baseurl" do
      stub_jekyll_config("baseurl" => "hello")
      expect(env.prefix_path).to(
        eq("hello/assets"))
    end

    #

    context "cdn? = true" do
      it "should add the cdn url" do
        stub_asset_config({
          "cdn" => {
            "url" => "hello.world",
            "prefix" => true
          }
        })

        allow(env).to(receive(:cdn?).and_return(true))
        expect(env.prefix_path).to(eq(
          "hello.world/assets"))
      end
    end

    #

    it "should add paths" do
      expect(env.prefix_path("hello.world")).to(
        eq("/assets/hello.world"))
    end
  end
end
