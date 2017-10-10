# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require_relative "extensible"

module Jekyll
  module Assets
    module Proxies
      DIG = Digest::SHA256
      DIR = "proxied"

      class ProxyDeleted < StandardError
        def initialize(obj)
          super "#{obj.to_s} violated a contract and " \
            "deleted your proxy file"
        end
      end

      module_function
      def run_proxies(type, args:, asset:, env:)
        proxies = Proxy.inherited.select do |o|
          o.for?({
            type: type,
            args: args,
          })
        end

        return asset if proxies.empty?
        file = copy_asset(asset, {
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

            obj.process
            if !file.exist?
              raise ProxyDeleted, o
            end
          end

          true
        end

        # Pull the asset from the proxied.
        out = env.manifest.find(file.basename.to_s)
        out.first
      end

      module_function
      def copy_asset(asset, env:, args:)
        raw = args.instance_variable_get(:@raw)
        key = DIG.hexdigest(raw)

        path = env.in_cache_dir(DIR)
        extname = File.extname(args[:argv1])
        out = Pathutil.new(path).join(key).sub_ext(extname)
        out.dirname.mkdir_p unless out.dirname.exist?
        Pathutil.new(asset.filename).cp(out)

        out
      end
    end

    class Proxy < Extensible
      attr_reader :file

      def self.args_key(key = nil)
        unless key.nil?
          @key = key
        end

        @key
      end

      def initialize(file, args:, asset:, env:)
        @args = args
        @asset = asset
        @jekyll = env.jekyll
        @file = file
        @env = env
      end

      def self.also_for?(type:, args:)
        args.key?(args_key)
      end
    end

    Hook.register :env, :init do
      dir = in_cache_dir(Proxies::DIR)
      append_path(dir)
    end
  end
end
