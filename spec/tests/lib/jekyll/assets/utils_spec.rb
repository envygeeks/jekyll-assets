# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe Jekyll::Assets::Utils do
  subject do
    env
  end

  #

  describe "#parse_liquid" do
    context "w/ {}" do
      it "parses" do
        expect(env.parse_liquid(hello: "{{ site }}")).to eq({
          hello: "Jekyll::Drops::SiteDrop",
        })
      end
    end

    #

    context "w/ []" do
      it "parses" do
        expect(env.parse_liquid(["{{ site }}"])).to eq([
          "Jekyll::Drops::SiteDrop",
        ])
      end
    end

    #

    context "w/ String" do
      it "parses" do
        expect(env.parse_liquid("{{ site }}")).to eq(
          "Jekyll::Drops::SiteDrop")
      end
    end
  end

  #

  describe "#in_cache_dir" do
    context "w/ asset_config[:caching][:path]" do
      before do
        stub_asset_config({
          caching: {
            path: "hello-cache",
          },
        })
      end

      #

      it "uses it" do
        expect(subject.in_cache_dir).to \
          end_with("/hello-cache")
      end
    end

    #

    it "allows paths" do
      expect(subject.in_cache_dir("one", "two")).to \
        end_with("one/two")
    end
  end

  #

  describe "#in_dest_dir" do
    context "w/ asset_config[:destination]" do
      before do
        stub_asset_config({
          destination: "/hello",
        })
      end

      #

      it "uses it" do
        rtn = subject.in_dest_dir
        expect(rtn).to end_with("/hello")
      end
    end

    #

    it "in site dir" do
      rtn = subject.in_dest_dir
      expect(rtn).to start_with(jekyll
        .in_dest_dir)
    end

    #

    it "allows paths" do
      rtn = subject.in_dest_dir("one", "two")
      expect(rtn).to end_with("one/two")
    end
  end

  #

  describe "#prefix_url" do
    let :cdn do
      "https://hello.cdn"
    end

    #

    before do
      stub_asset_config({
        cdn: {
          url: cdn,
        },
      })
    end

    #

    context "production" do
      before do
        allow(Jekyll).to receive(:dev?).and_return(false)
        allow(Jekyll).to receive(:production?)
          .and_return(true)
      end

      #

      context "w/ asset_config[:cdn][:url]" do
        it "uses it" do
          out = subject.prefix_url
          expect(out).to start_with(cdn)
        end
      end

      #

      context "jekyll.config[:baseurl]" do
        before do
          stub_jekyll_config({
            baseurl: "hello",
          })
        end

        #

        context do
          before do
            stub_asset_config({
              cdn: {
                url: nil,
              },
            })
          end

          #

          it "uses it" do
            out = subject.prefix_url
            expect(out).to start_with("/hello")
          end
        end

        #

        context "w/ asset_config[:cdn][:url]" do
          context "asset_config[:cdn][:baseurl]" do
            context "w/ true" do
              before do
                stub_asset_config({
                  cdn: {
                    baseurl: true,
                  },
                })
              end

              #

              it "uses it" do
                out = subject.prefix_url
                expect(out).to end_with("/hello")
              end
            end

            #

            context "w/ false" do
              it "doesn't use it" do
                out = subject.prefix_url
                expect(out).not_to end_with("/hello")
              end
            end
          end
        end
      end

      #

      context "asset_config[:destination]" do
        context do
          before do
            stub_asset_config({
              cdn: {
                url: nil,
              },
            })
          end

          #

          it "uses it" do
            out = subject.prefix_url
            destination = subject.asset_config[:destination]
            expect(out).to eq(destination)
          end
        end

        #

        context "w/ asset_config[:cdn][:destination]" do
          context "w/ true" do
            before do
              stub_asset_config({
                cdn: {
                  destination: true,
                },
              })
            end

            #

            it "uses it" do
              out = subject.prefix_url
              destination = subject.asset_config[:destination]
              expect(out).to end_with(destination)
            end
          end

          #

          context "w/ false" do
            it "doesn't use it" do
              out = subject.prefix_url
              destination = subject.asset_config[:destination]
              expect(out).not_to end_with(destination)
            end
          end
        end
      end
    end

    #

    context "development" do
      context "w/ asset_config[:cdn][:url]" do
        let :cdn do
          "https://my.cdn"
        end

        before do
          stub_asset_config({
            cdn: {
              url: cdn,
            },
          })
        end

        #

        it "doesn't use it" do
          out = subject.prefix_url
          destination = subject.asset_config[:destination]
          expect(out).to eq(destination)
        end
      end

      #

      context "w/ jekyll.config[:baseurl]" do
        before do
          stub_jekyll_config({
            baseurl: "hello",
          })
        end

        #

        it "uses it" do
          out = subject.prefix_url
          expect(out).to start_with("/hello")
        end
      end

      #

      context "w/ asset_config[:destination]" do
        it "uses it" do
          out = subject.prefix_url
          destination = subject.asset_config[:destination]
          expect(out).to eq(destination)
        end
      end
    end
  end
end
