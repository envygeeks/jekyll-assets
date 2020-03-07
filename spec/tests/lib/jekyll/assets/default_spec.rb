# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "rspec/helper"

# --
module Jekyll
  module Assets
    class Default
      class Test1 < Default
        static hello: :world
        content_types :test
      end

      #

      class Test2 < Default
        static world: :hello
        content_types :test

        def run
          args.update({
            hello: :world,
          })
        end
      end
    end
  end
end

#

describe Jekyll::Assets::Default do
  before do
    allow(asset).to receive(:content_type)
      .and_return(:test)
  end

  #

  let :asset do
    env.find_asset!("img.png")
  end

  #

  describe ".get" do
    subject do
      described_class.get({
        type: :test,
        args: {
          #
        },
      })
    end

    #

    it "is indifferent" do
      expect(subject).to be_a(HashWithIndifferentAccess)
    end

    #

    it "merges" do
      expect(subject).to(eq({
        "hello" => :world,
        "world" => :hello,
      }))
    end
  end

  #

  describe ".set" do
    it "sets defaults" do
      subject.set(result = {}, {
        asset: asset, ctx: Thief.ctx
      })

      expect(result[:hello]).to eq(:world)
    end

    #

    context "w/ false attrs" do
      let :page do
        site.pages.find do |v|
          v.path == "defaults.html"
        end
      end

      #

      it "doesn't set" do
        file = fragment(page.output)
        expect(file.search("img").first[:integrity]).to be_nil
        expect(file.search("link").first[:integrity]).to be_nil
        expect(file.search("link").first[:type]).to be_nil
      end
    end
  end
end
