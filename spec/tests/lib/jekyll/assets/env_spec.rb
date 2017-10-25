# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require "rspec/helper"
describe Jekyll::Assets::Env do
  subject do
    env
  end

  describe "#find_asset!" do
    context "w/ string" do
      it "works" do
        out = subject.find_asset!("img.png")
        expect(out).to(be_a(Sprockets::Asset))
      end
    end

    context "w/ assets" do
      it "works" do
        out = subject.manifest.find("img.png")
        out = subject.find_asset!(out.first)
        expect(out).to(be_a(Sprockets::Asset))
      end
    end
  end

  describe "#find_source!" do
    context "w/ double extensions" do
      it "works" do
        out = subject.find_source!("plugins/liquid.scss.liquid")
        expect(out).to(be_a(Sprockets::Asset))
      end
    end

    context "w/ string" do
      it "works" do
        out = subject.find_source!("bundle.css")
        expect(out).to(be_a(Sprockets::Asset))
      end
    end

    context "w/ assets" do
      it "works" do
        out = subject.manifest.find("bundle.scss")
        out = subject.find_source!(out.first)
        expect(out).to(be_a(Sprockets::Asset))
      end
    end

    it "returns source" do
      out = subject.find_source!("bundle.css").source
      compare = env.manifest.find("bundle.source.css").first.source
      expect(out).to(eq(compare))
    end
  end

  describe "#compile" do
    context "w/ source extension" do
      it "corrects" do
        out = subject.compile("bundle.scss").content_type
        expect(out).to(eq("text/css"))
      end
    end

    context do
      before do
        asset = subject.find_asset!("bundle.css")
        asset = subject.in_dest_dir(asset.digest_path)
        Pathutil.new(asset).rm_f
      end

      it "works" do
        out = subject.compile("bundle.css")
        out = subject.in_dest_dir(out.digest_path)
        out = Pathutil.new(out)
        expect(out).to(exist)
      end
    end
  end

  describe "#cache" do
    before do
      subject.instance_variable_set(:@cache, nil)
    end

    context "asset_config[:caching][:type]" do
      context "w/ nil" do
        before do
          stub_asset_config({
            caching: {
              type: nil
            }
          })
        end

        it "defaults" do
          out = subject.cache
          expect(out).to(be_a(Sprockets::Cache))
        end
      end

      context "w/ empty" do
        before do
          stub_asset_config({
            caching: {
              type: ""
            }
          })
        end

        it "defaults" do
          out = subject.cache
          expect(out).to(be_a(Sprockets::Cache))
        end
      end
    end
  end

  describe "#asset_config" do
    before do
      subject.instance_variable_set(:@asset_config, nil)
      stub_jekyll_config({
        assets: {
          hello: :world
        }
      })
    end

    it "merges" do
      out = subject.asset_config[:hello]
      expect(out).to(eq(:world))
    end
  end

  describe "#to_liquid_payload" do
    it "returns Hash<String,Drop>" do
      out = subject.to_liquid_payload
      out.each do |_, v|
        expect(v).to(be_a(Jekyll::Assets::Drop))
      end
    end

    it "is a Hash" do
      out = subject.to_liquid_payload
      expect(out).to(be_a(Hash))
    end
  end

  describe "#in_cache_dir" do
    context "w/ asset_config[:caching][:path]" do
      before do
        stub_asset_config({
          caching: {
            path: "hello-cache"
          }
        })
      end

      it "uses it" do
        out = subject.in_cache_dir
        expect(out).to(end_with("/hello-cache"))
      end
    end

    it "allows paths" do
      out = subject.in_cache_dir("one", "two")
      expect(out).to(end_with("one/two"))
    end

    it "in source dir" do
      out = subject.in_cache_dir
      expect(out).to(start_with(jekyll
        .in_source_dir))
    end
  end

  describe "#in_dest_dir" do
    context "w/ asset_config[:destination]" do
      before do
        stub_asset_config({
          destination: "/hello"
        })
      end

      it "uses it" do
        out = subject.in_dest_dir
        expect(out).to(end_with("/hello"))
      end
    end

    it "in site dir" do
      out = subject.in_dest_dir
      expect(out).to(start_with(jekyll
        .in_dest_dir))
    end

    it "allows paths" do
      out = subject.in_dest_dir("one", "two")
      expect(out).to(end_with("one/two"))
    end
  end

  describe "#prefix_url" do
    let :cdn do
      "https://hello.cdn"
    end

    before do
      stub_asset_config({
        cdn: {
          url: cdn
        }
      })
    end

    context "production" do
      before do
        allow(Jekyll).to(receive(:dev?)).and_return(false)
        allow(Jekyll).to(receive(:production?))
          .and_return(true)
      end

      context "w/ asset_config[:cdn][:url]" do
        it "uses it" do
          out = subject.prefix_url
          expect(out).to(start_with(cdn))
        end
      end

      context "jekyll.config[:baseurl]" do
        before do
          stub_jekyll_config({
            baseurl: "hello"
          })
        end

        context do
          before do
            stub_asset_config({
              cdn: {
                url: nil
              }
            })
          end

          it "uses it" do
            out = subject.prefix_url
            expect(out).to(start_with("/hello"))
          end
        end

        context "w/ asset_config[:cdn][:url]" do
          context "asset_config[:cdn][:baseurl]" do
            context "w/ true" do
              before do
                stub_asset_config({
                  cdn: {
                    baseurl: true
                  }
                })
              end

              it "uses it" do
                out = subject.prefix_url
                expect(out).to(end_with("/hello"))
              end
            end

            context "w/ false" do
              it "doesn't use it" do
                out = subject.prefix_url
                expect(out).not_to(end_with("/hello"))
              end
            end
          end
        end
      end

      context "asset_config[:destination]" do
        context do
          before do
            stub_asset_config({
              cdn: {
                url: nil
              }
            })
          end

          it "uses it" do
            out = subject.prefix_url
            destination = subject.asset_config[:destination]
            expect(out).to(eq(destination))
          end
        end

        context "w/ asset_config[:cdn][:destination]" do
          context "w/ true" do
            before do
              stub_asset_config({
                cdn: {
                  destination: true
                }
              })
            end

            it "uses it" do
              out = subject.prefix_url
              destination = subject.asset_config[:destination]
              expect(out).to(end_with(destination))
            end
          end

          context "w/ false" do
            it "doesn't use it" do
              out = subject.prefix_url
              destination = subject.asset_config[:destination]
              expect(out).not_to(end_with(destination))
            end
          end
        end
      end
    end

    context "development" do
      context "w/ asset_config[:cdn][:url]" do
        let :cdn do
          "https://my.cdn"
        end

        before do
          stub_asset_config({
            cdn: {
              url: cdn
            }
          })
        end

        it "doesn't use it" do
          out = subject.prefix_url
          destination = subject.asset_config[:destination]
          expect(out).to(eq(destination))
        end
      end

      context "w/ jekyll.config[:baseurl]" do
        before do
          stub_jekyll_config({
            baseurl: "hello"
          })
        end

        it "uses it" do
          out = subject.prefix_url
          expect(out).to(start_with("/hello"))
        end
      end

      context "w/ asset_config[:destination]" do
        it "uses it" do
          out = subject.prefix_url
          destination = subject.asset_config[:destination]
          expect(out).to(eq(destination))
        end
      end
    end
  end
end
