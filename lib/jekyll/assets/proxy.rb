# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Proxies
      DIR = "proxied"

      class ProxyDeleted < StandardError
        def initialize(obj)
          super "#{obj.to_s} violated a contract and " \
            "deleted your proxy file"
        end
      end

      # --
      # @param args [Hash] the current arguments hash.
      # @param jekyll [Jekyll::Site] the Jekyll instance (w/ Sprockets.)
      # @param tag [String] the tag you are working with.
      # run_proxies runs all your proxy plugins.
      # @return [Nil]
      # --
      module_function
      def run_proxies(tag, args:, asset:, env:)
        file = copy_asset(asset, env: env, args: args)

        env.cache.fetch(file.basename.sub_ext("").to_s) do
          Proxy.inherited.select { |o| o.for?(tag, args) }.each do |o|
            o.new(file, args: args, asset: asset, env: env).process
            if !file.exist?
              raise ProxyDeleted, o
            end
          end

          true
        end

        name = file.basename.to_s
        env.manifest.find(name).
          first
      end

      # --
      # @private
      # @param [Sprockets::Asset] asset the asset.
      # @param [Jekyll::Assets::Env] env the environment.
      # copy_asset copies an asset to a temporary directory to be worked on.
      # @note the path you are working in is in the asset path.
      # @note this is replicatable.
      # @return [Pathutil]
      # --
      module_function
      def copy_asset(asset, env:, args:)
        path = env.in_cache_dir(DIR)
        name = Digest::SHA256.hexdigest(args.instance_variable_get(:@raw))
        file = Pathutil.new(path).join(name).sub_ext(File.extname(args[:argv1]))
        file.dirname.mkdir_p unless file.dirname.exist?
        Pathutil.new(asset.filename).cp(file)

        file
      end
    end

    #

    class Proxy
      attr_reader :file

      def self.inherited(kls = nil)
        return @inherited ||= [] if kls.nil?
        (@inherited ||= []) \
          << kls
      end

      # --
      # @param [Symbol] key the @args key to accept.
      # @param [Array,Symbol] tags the tags you wish to work on.
      # proxy_info wraps around `tags` and `key` to set in one method.
      # @note this is the perferred internal method.
      # @return [nil]
      # --
      def self.proxy_info(tags:, key:)
        unless tags.is_a?(Array)
          tags = [
            tags
          ]
        end

        key(*key)
        tags(*tags)
        nil
      end

      # --
      # @param [Array<String,Symbol>] tags the tags.
      # defaults_for allows you to set the name of the tags to work on.
      # @return [nil]
      # --
      def self.tags(*tags)
        return @tags ||= [] if tags.empty?

        @tags ||= []
        tags = tags.map(&:to_sym)
        @tags  |= tags
      end

      # --
      # @param [Array<String,Symbol>] tags the tags.
      # defaults_for allows you to set the name of the tags to work on.
      # @return [nil]
      # --
      def self.key(key = nil)
        key ? (@key = key) : @key
      end

      # --
      # @param [String,Symbol] tag the tag.
      # for? allows us to check and see if this supports a tag.
      # @return [true, false]
      # --
      def self.for?(tag, args)
        args.key?(key) && tags.include?(tag.to_sym)
      end

      # --
      def initialize(file, args:, asset:, env:)
        @args = args
        @asset = asset
        @jekyll = env.jekyll
        @file = file
        @env = env
      end
    end

    Hook.register :env, :init, priority: 1 do
      append_path(in_cache_dir("proxied"))
    end
  end
end
