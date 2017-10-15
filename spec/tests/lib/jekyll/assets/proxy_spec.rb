# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

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
  let(:asset) { environment.find_asset!(args[:argv1]) }
  let(:klass) { Jekyll::Assets::Plugins::ProxyTest1 }
  let :args do
    Liquid::Tag::Parser.new("img.png @test:2x")
  end

  it "should call the proxy" do
    expect_any_instance_of(klass).to(receive(:process))
    expect(klass).to(receive(:new).and_call_original)
    subject.proxy(asset, {
      args: args,
      env: environment,
      type: :test,
    })
  end

  it "should return an asset" do
    out = subject.proxy(asset, {
      args: args,
      env: environment,
      type: :test,
    })

    expect(out).to(be_a(Sprockets::Asset))
    path = Pathutil.new(environment.in_cache_dir(subject::DIR)).children
    expect(path).to(include(out.filename))
  end

  context do
    let(:dir) { Pathutil.new(environment.in_cache_dir(subject::DIR)) }
    it "should copy the asset" do
      out = subject.proxy(asset, {
        args: args,
        env: environment,
        type: :test,
      })

      expect(dir.children.size).to be >= 1
      expect(Pathutil.new(out.filename).binread).to(eq(Pathutil.
        new(asset.filename).binread))
    end
  end
end
