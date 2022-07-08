# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

require 'digest'

module Jekyll
  module Assets
    class Proxy < Extensible
      attr_reader :file

      class Deleted < StandardError
        def initialize(obj)
          super "#{obj} violated a contract and " \
            'deleted your proxy file'
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
        env = ctx.registers[:site].sprockets
        return asset if (proxies = proxies_for(asset: asset, args: args)).empty?
        key = digest(args)

        out = env.cache.fetch(key) do
          file = copy(asset, args: args, ctx: ctx)
          proxies.each do |o|
            obj = o.new(file,
              args: args,
              asset: asset,
              ctx: ctx
            )

            o = obj.process
            file = o if o.is_a?(Pathutil) && file != o
            raise Deleted, o unless file.exist?
          end

          file
        end

        env.find_asset!(out)
      end

      # --
      def self.proxies_for(asset:, args:)
        Proxy.inherited.select do |o|
          o.for?(
            type: asset.content_type,
            args: args,
          )
        end
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

        path = env.in_cache_dir('proxied')
        extname = File.extname(args[:argv1])
        out = Pathutil.new(path).join(digest(args))
          .sub_ext(extname)

        unless out.file?
          out.dirname.mkdir_p
          Pathutil.new(asset.filename).cp(
            out
          )
        end

        out
      end

      def self.digest(args)
        Digest::SHA256.hexdigest(args.to_h.inspect)[0, 6]
      end

      # --
      # @return [Symbol] the argument key.
      # Allows you to tell the proxier which args are yours.
      # @note we will not run your proxy if the argkey doen't match.
      # @param [Symbol] key the key.
      # --
      def self.args_key(key = nil)
        key.nil? ? @key : @key = key
      end

      # --
      # Return a list of proxy keys.
      # This allows you to select their values from args.
      # @return [Array<Symbol>]
      # --
      def self.keys
        inherited.map(&:arg_keys).flatten
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
  append_path(
    in_cache_dir(
      'proxied'
    )
  )
end
