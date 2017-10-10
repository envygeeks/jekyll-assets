# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "fastimage"
require "liquid/tag/parser"
require "active_support/hash_with_indifferent_access"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/hash/deep_merge"
require "nokogiri"

module Jekyll
  module Assets
    class Tag < Liquid::Tag
      class << self
        public :new
      end

      def initialize(tag, args, tokens)
        @tag = tag.to_sym
        @args = Liquid::Tag::Parser.new(args)
        @name = @args[:argv1]
        @tokens = tokens

        super
      end

      def render(context)
        env = context.registers[:site].sprockets
        asset = env.manifest.find(@name).first

        if asset
          type = asset.content_type
          Defaults.set(@args, {
            type: type,
            asset: asset,
            env: env
          })

          env.manifest.compile(@name)
          return asset.data_uri if @args[:"data-uri"]
          return env.prefix_path(asset.digest_path) if @args[:path]
          return asset.to_s if @args[:source]
          type = asset.content_type

          HTML.build({
            type: type,
            asset: asset,
            args: @args,
            env: env
          })
        else
          env.logger.error "unable to find: #{@name} -- SKIPPING"
          if env.asset_config[:strict]
            raise Errors::AssetNotFound, @name
          end
        end
      end
    end
  end
end

# --

Liquid::Template.register_tag "asset", Jekyll::Assets::Tag
