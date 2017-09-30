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

  describe "#prefix_path" do
    context "with !cdn.url" do
      context "with dev? = true" do
        it "should not try to add the cdn" do
          stub_asset_config({ "cdn" => { "url" => "hello.com" }})
          allow(env).to(receive(:dev?).
            and_return(true))

          expect(env.prefix_path).to(eq("/assets"))
        end
      end

      #

      context "with dev? = true" do
        it "should add the cnd.url" do
          stub_asset_config({ "cdn" => { "url" => "hello.com" }})
          allow(env).to(receive(:dev?).
            and_return(false))

          expect(env.prefix_path).to(eq("hello.com"))
        end
      end
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

  describe "baseurl" do
    shared_examples :baseurl_tests do
      it "adds baseurl" do
        stub_jekyll_config({
          "baseurl" => "hello"
        })

        expect(env.baseurl).to(eq("hello/assets"))
      end

      #

      it "adds prefix" do
        allow(env).to(receive(:cdn?).and_return(false))
        stub_asset_config({
          "cdn" => {
            "prefix" => true,
          }
        })

        expect(env.baseurl).to(eq("/assets"))
      end
    end

    #

    context "when cdn is false" do
      it_behaves_like :baseurl_tests do
        before :each do
          allow(env).to(receive(:cdn?).and_return(false))
        end
      end
    end

    #

    context "when cdn is true" do
      it_behaves_like :baseurl_tests do
        before :each do
          allow(env).to(receive(:cdn?).and_return(false))
        end
      end
    end

    #

    context "when cdn is true" do
      context "when cdn.prefix is false" do
        it "should not prefix" do
          allow(env).to(receive(:cdn?).and_return(true))
          stub_asset_config({
            "cdn" => {
              "prefix" => false
            }
          })

          expect(env.baseurl).to(eq(""))
        end
      end

      #

      context "when cdn.baseurl is false" do
        it "should not baseurl" do
          allow(env).to(receive(:cdn?).and_return(true))
          stub_jekyll_config("baseurl" => "hello")
          stub_asset_config({
            "cdn" => {
              "baseurl" => false
            }
          })

          expect(env.baseurl).to(eq(""))
        end
      end
    end
  end
end
