# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require "rspec/helper"

# --
module Jekyll
  module Assets
    module Plugins
      class ProxyTest1 < Proxy
        args_key :test
        types :test

        def process
          nil
        end
      end

      class ProxyTest2 < Proxy
        args_key :test
        types :test

        def process
          nil
        end
      end
    end
  end
end

describe Jekyll::Assets::Proxy do
  let(:klass) { Jekyll::Assets::Plugins::ProxyTest1 }
  let(:args) { Liquid::Tag::Parser.new("img.png @test:2x") }
  let(:asset) { env.find_asset!(args[:argv1]) }

  it "should call the proxy" do
    expect_any_instance_of(klass).to(receive(:process))
    expect(klass).to(receive(:new).and_call_original)
    subject.proxy(asset, {
      args: args,
      type: :test,
      env: env
    })
  end

  it "should return an asset" do
    out = subject.proxy(asset, {
      args: args,
      type: :test,
      env: env
    })

    expect(out).to(be_a(Sprockets::Asset))
    path = Pathutil.new(env.in_cache_dir(subject::DIR)).children
    expect(path).to(include(out.filename))
  end

  context do
    let(:dir) { Pathutil.new(env.in_cache_dir(subject::DIR)) }
    it "should copy the asset" do
      out = subject.proxy(asset, {
        args: args,
        type: :test,
        env: env
      })

      expect(dir.children.size).to be >= 1
      expect(Pathutil.new(out.filename).binread).to(eq(Pathutil
        .new(asset.filename).binread))
    end
  end
end
