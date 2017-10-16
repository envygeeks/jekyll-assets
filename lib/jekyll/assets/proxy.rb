# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "pathutil"
require_relative "extensible"
require_relative "hook"
require "digest"

module Jekyll
  module Assets
    class Proxy < Extensible
      attr_reader :file
      DIG = Digest::SHA256
      DIR = "proxied"

      class Deleted < StandardError
        def initialize(obj)
          super "#{obj.to_s} violated a contract and " \
            "deleted your proxy file"
        end
      end

      def self.proxy(asset, type:, args:, env:)
        proxies = Proxy.inherited.select do |o|
          o.for?({
            type: type,
            args: args,
          })
        end

        return asset if proxies.empty?
        file = copy(asset, {
          args: args,
           env: env,
        })

        cache = file.basename.sub_ext("").to_s
        env.cache.fetch(cache) do
          proxies.each do |o|
            obj = o.new(file, {
               args: args,
              asset: asset,
                env: env,
            })

            o = obj.process
            file = o if o.is_a?(Pathutil) && file != o
            raise Deleted, o if !file.exist?
          end

          true
        end

        env.find_asset!(file)
      end

      def self.copy(asset, env:, args:)
        raw = args.instance_variable_get(:@raw)
        key = DIG.hexdigest(raw)[0,6]

        path = env.in_cache_dir(DIR)
        extname = File.extname(args[:argv1])
        out = Pathutil.new(path).join(key).sub_ext(extname)
        out.dirname.mkdir_p unless out.dirname.exist?
        Pathutil.new(asset.filename).cp(out)

        out
      end

      def self.args_key(key = nil)
        unless key.nil?
          @key = key
        end

        @key
      end

      def initialize(file, **kwd)
        super(**kwd)
        @file = file
      end

      def self.for?(type:, args:)
        super && args.key?(args_key)
      end
    end
  end
end

Jekyll::Assets::Hook.register :env, :init do
  append_path(in_cache_dir(Jekyll::Assets::Proxy::DIR))
end
