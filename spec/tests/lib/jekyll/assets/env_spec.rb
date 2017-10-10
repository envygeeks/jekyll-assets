# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Env do
  subject { env }
  let(:path) do
    site.in_dest_dir("/assets")
  end

  describe "#manifest" do
    it "should put the path in Jekyll's dest dir" do
      expect(env.manifest.path).to(start_with(env.jekyll.source))
    end
  end

  describe "#to_liquid_payload" do
    it "should build a list of liquid drops" do
      expect(env.to_liquid_payload).to(be_a(Hash))
      env.to_liquid_payload.each do |_, v|
        expect(v).to(be_a(Jekyll::Assets::Drop))
      end
    end
  end

  describe "#precompile!" do
    before do
      stub_asset_config({
        precompile: [
          "img.png"
        ]
      })

      env.send(:precompile!)
    end

    let(:asset) { env.manifest.find("img.png").first }
    it "should compile those extra assets" do
      expect(Pathutil.new(env.in_dest_dir(asset.digest_path))).to(exist)
    end
  end

  describe "#baseurl" do
    context "when cdn? = true" do
      context "and when cdn.baseurl = true" do
        before do
          env.instance_variable_set(:@baseurl, nil)
          stub_asset_config({
            cdn: {
              baseurl: true
            }
          })

          allow(env).to(receive(:cdn?).and_return(true))
          stub_jekyll_config({
            baseurl: "hello"
          })
        end

        it "should add baseurl" do
          expect(env.baseurl).to(eq("hello"))
        end
      end

      context "and when cdn.baseurl = false" do
        before do
          env.instance_variable_set(:@baseurl, nil)
          stub_asset_config({
            cdn: {
              baseurl: false
            }
          })

          allow(env).to(receive(:cdn?).and_return(true))
          stub_jekyll_config({
            baseurl: "hello"
          })
        end

        it "doesn't add baseurl" do
          expect(env.baseurl).to(eq(""))
        end
      end

      context "and when cdn.prefix = true" do
        before do
          allow(env).to(receive(:cdn?).and_return(true))
          env.instance_variable_set(:@baseurl, nil)
          stub_asset_config({
            cdn: {
              prefix: true
            }
          })
        end

        it "should add the prefix" do
          expect(env.baseurl).to(eq("/assets"))
        end
      end

      context "and when cdn.prefix = false" do
        before do
          allow(env).to(receive(:cdn?).and_return(true))
          env.instance_variable_set(:@baseurl, nil)
          stub_asset_config({
            cdn: {
              prefix: false
            }
          })
        end

        it "doesn't add prefix" do
          expect(env.baseurl).to(eq(""))
        end
      end
    end
  end

  describe "#prefix_path" do
    context do
      before do
        stub_jekyll_config({
          baseurl: "hello"
        })
      end

      it "should add the baseurl" do
        expect(env.prefix_path).to(eq("hello/assets"))
      end
    end

    context "cdn? = true" do
      before do
        allow(env).to(receive(:cdn?).and_return(true))
        stub_asset_config({
          cdn: {
            url: "hello.world",
            prefix: true,
          }
        })
      end

      it "should add the cdn url" do
        expect(env.prefix_path).to(eq("hello.world/assets"))
      end
    end

    it "should add paths" do
      expect(env.prefix_path("hello.world")).to(eq("/assets/hello.world"))
    end
  end
end
