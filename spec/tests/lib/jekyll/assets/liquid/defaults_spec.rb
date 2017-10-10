# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "rspec/helper"

# --
module Jekyll
  module Assets
    module Plugins
      class DefaultsTest1 < Liquid::Default
        static hello: :world
        types :test
      end

      class DefaultsTest2 < Liquid::Default
        static world: :hello
        types :test

        def run
          @args.update({
            hello: :world
          })
        end
      end
    end
  end
end

describe Jekyll::Assets::Liquid::Defaults do
  before { allow(asset).to(receive(:content_type).and_return(:test)) }
  let :asset do
    env.manifest.find("img.png").first
  end

  describe "get" do
    subject do
      described_class.get({
        type: :test,
        args: {
          #
        },
      })
    end

    it "should give an indifferent hash" do
      expect(subject).to(be_a(HashWithIndifferentAccess))
    end

    it "should merge values" do
      expect(subject).to(eq({
        "hello" => :world,
        "world" => :hello,
      }))
    end
  end

  describe "set_defaults" do
    it "should run and set defaults" do
      result = {}

      subject.set(result, {
        type: :test,
        asset: asset,
        env: env,
      })

      expect(result).to(have_key(:hello))
      expect(result[:hello]).to(eq(:world))
    end
  end
end
