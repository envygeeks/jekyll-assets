# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "rspec/helper"

# --
module Jekyll
  module Assets
    module Plugins
      class ProxyTest1 < Proxy
        content_types :test
        arg_keys :test

        def process
          nil
        end
      end

      #

      class ProxyTest2 < Proxy
        content_types :test
        arg_keys :test

        def process
          nil
        end
      end
    end
  end
end

#

describe Jekyll::Assets::Proxy do
  let(:klass) { Jekyll::Assets::Plugins::ProxyTest1 }
  before { allow(asset).to(receive(:content_type).and_return(:test)) }
  let(:args) { Liquid::Tag::Parser.new("img.png @test:2x") }
  let(:asset) { env.find_asset!(args[:argv1]) }

  #

  it "calls" do
    expect_any_instance_of(klass).to(receive(:process))
    expect(klass).to(receive(:new).and_call_original)
    subject.proxy(asset, {
      ctx: Thief.ctx, args: args
    })
  end

  #

  it "returns <Asset>" do
    out = subject.proxy(asset, {
      args: args, ctx: Thief.ctx
    })

    expect(out).to(be_a(Sprockets::Asset))
    path = Pathutil.new(env.in_cache_dir("proxied")).children
    expect(path).to(include(out.filename))
  end

  #

  context do
    let(:dir) do
      Pathutil.new(env.in_cache_dir("proxied"))
    end

    #

    it "copies" do
      out = subject.proxy(asset, {
        args: args, ctx: Thief.ctx
      })

      expect(dir.children.size).to be >= 1
      expect(Pathutil.new(out.filename).binread).to(eq(Pathutil
        .new(asset.filename).binread))
    end
  end
end
