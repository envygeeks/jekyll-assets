# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "pathutil"
require_relative "extensible"
require_relative "hook"
require "digest"

module Jekyll
  module Assets
    class Proxy < Extensible
      attr_reader :file

      class Deleted < StandardError
        def initialize(obj)
          super "#{obj} violated a contract and " \
            "deleted your proxy file"
        end
      end

      # --
      # @param [Hash] args the args.
      # @param [Sprockets::Asset] asset the asset.
      # @param [String] type the assets content_type
      # @param [Env] env the environment.
      # Run all your proxies on assets.
      # @return [Sprockets::Asset]
      # --
      def self.proxy(asset, args:, ctx:)
        proxies = Proxy.inherited.select do |o|
          o.for?(type: asset.content_type, args: args)
        end

        return asset if proxies.empty?
        env = ctx.registers[:site].sprockets
        file = copy(asset, args: args, ctx: ctx)
        cache = file.basename.sub_ext("").to_s

        env.cache.fetch(cache) do
          proxies.each do |o|
            obj = o.new(file, {
              args: args,
              asset: asset,
              ctx: ctx,
            })

            o = obj.process
            file = o if o.is_a?(Pathutil) && file != o
            raise Deleted, o unless file.exist?
          end

          true
        end

        env.find_asset!(file)
      end

      # --
      # Copy the asset to the proxied directory.
      # @note this is done so we do not directly alter.
      # @param [Sprockets::Asset] asset the current asset.
      # @param [Env] env the environment.
      # @param [Hash] args the args.
      # @return [Pathutil]
      # --
      def self.copy(asset, ctx:, args:)
        env = ctx.registers[:site].sprockets

        path = env.in_cache_dir("proxied")
        extname = File.extname(args[:argv1])
        out = Pathutil.new(path).join(digest(args))
          .sub_ext(extname)

        unless out.file?
          out.dirname.mkdir_p
          Pathutil.new(asset.filename)
            .cp(out)
        end

        out
      end

      def self.digest(args)
        Digest::SHA256.hexdigest(args.instance_variable_get(
          :@raw))[0, 6]
      end

      # --
      # @return [Symbol] the argument key.
      # Allows you to tell the proxier which args are yours.
      # @note we will not run your proxy if the argkey doen't match.
      # @param [Symbol] key the key.
      # --
      def self.args_key(key = nil)
        unless key.nil?
          @key =
            key
        end

        @key
      end

      # --
      def initialize(file, **kwd)
        super(**kwd)
        @file = file
      end
    end
  end
end

Jekyll::Assets::Hook.register :env, :after_init do
  append_path(in_cache_dir("proxied"))
end
