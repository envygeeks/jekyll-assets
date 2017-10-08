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
    module Liquid
      class Tag < ::Liquid::Tag

        # --
        # Liquid doesn't like to make it's new method public
        # so we go back and make it public so that we can ship
        # this tag from within filters.
        # --
        class << self
          public :new
        end

        # --
        TAGS = [
          :img,
          :css,
          :js,
        ]

        # --
        HTML = {
          css: :link,
          js:  :script,
          img: :img,
        }

        # --
        def initialize(tag, args, tokens)

          @tag = tag.to_sym
          @args = ::Liquid::Tag::Parser.new(args)
          @args.deep_merge!(Defaults.get_defaults(tag).deep_symbolize_keys)
          @name = @args[:argv1]
          @tokens = tokens

          super
        end

        # --
        def render(context)
          env = context.registers[:site].sprockets
          asset = env.manifest.find(@name).first

          if asset
            return asset.to_s if @args[:source]
            if @args[:"data-uri"]
              return asset.data_uri
            end

            env.manifest.compile(@name)
            doc = Nokogiri::HTML::DocumentFragment.parse("")
            Defaults.set_defaults(@tag, asset: asset, env: env, args: @args)
            path = env.prefix_path(asset.digest_path)
            return path if @args[:path] == true

            Nokogiri::HTML::Builder.with(doc) do |d|
              d.send(HTML[@tag], @args.to_html({
                hash: true
              }))
            end

            doc.to_html
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
end

# --

Jekyll::Assets::Liquid::Tag::TAGS.each do |v|
  Liquid::Template.register_tag v, Jekyll::Assets::Liquid::Tag
end
