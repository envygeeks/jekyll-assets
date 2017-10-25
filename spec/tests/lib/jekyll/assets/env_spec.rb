# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Env do
  subject do
    env
  end

  #

  describe "#cache" do
    before do
      subject.instance_variable_set(:@cache, nil)
    end

    #

    context "asset_config[:caching][:type]" do
      context "w/ nil" do
        before do
          stub_asset_config({
            caching: {
              type: nil
            }
          })
        end

        #

        it "defaults" do
          expect(subject.cache).to(be_a(Sprockets::Cache))
        end
      end

      #

      context "w/ empty" do
        before do
          stub_asset_config({
            caching: {
              type: ""
            }
          })
        end

        #

        it "defaults" do
          expect(subject.cache).to(be_a(Sprockets::Cache))
        end
      end
    end
  end

  #

  describe "#asset_config" do
    before do
      stub_jekyll_config({
        assets: {
          hello: :world
        }
      })
    end

    #

    subject do
      described_class.new(jekyll)
    end

    #

    it "merges" do
      expect(subject.asset_config[:hello]).to(eq(:world))
    end
  end

  #

  describe "#to_liquid_payload" do
    it "returns Hash<String,Drop>" do
      subject.to_liquid_payload.each do |_, v|
        expect(v).to(be_a(Jekyll::Assets::Drop))
      end
    end

    #

    it "is a Hash" do
      expect(subject.to_liquid_payload).to(be_a(Hash))
    end
  end

  #

  describe "#in_cache_dir" do
    context "w/ asset_config[:caching][:path]" do
      before do
        stub_asset_config({
          caching: {
            path: "hello-cache"
          }
        })
      end

      #

      it "uses it" do
        expect(subject.in_cache_dir).to(end_with("/hello-cache"))
      end
    end

    #

    it "allows paths" do
      expect(subject.in_cache_dir("one", "two")).to(end_with("one/two"))
    end

    #

    it "in source dir" do
      expect(subject.in_cache_dir).to(start_with(jekyll.in_source_dir))
    end
  end

  #

  describe "#in_dest_dir" do
    context "w/ asset_config[:destination]" do
      before do
        stub_asset_config({
          destination: "/hello"
        })
      end

      #

      it "uses it" do
        rtn = subject.in_dest_dir
        expect(rtn).to(end_with("/hello"))
      end
    end

    it "in site dir" do
      rtn = subject.in_dest_dir
      expect(rtn).to(start_with(jekyll.
        in_dest_dir))
    end

    it "allows paths" do
      rtn = subject.in_dest_dir("one", "two")
      expect(rtn).to(end_with("one/two"))
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
        allow(Jekyll).to(receive(:production?)).
          and_return(true)
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
