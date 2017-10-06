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
          :asset_path,
          :asset,
          :css,
          :js,
        ]

        # --
        def initialize(tag, args, tokens)
          @parser = ::Liquid::Tag::Parser.new(args)

          @tokens = tokens
          @args = HashWithIndifferentAccess.new(@parser.args)
          @args = @args.deep_merge(Defaults.get_defaults(tag))
          @original_args = args
          @tag = tag

          super
        end

        # --
        def render(context)
          sprockets = context.registers[:site].sprockets
          asset = sprockets.manifest.find(@args[:argv1]).first
          sprockets.manifest.compile(@args[:argv1]) if asset

          require"pry"
          Pry.output = STDOUT
          binding.pry
        end
      end
    end
  end
end

# --

Jekyll::Assets::Liquid::Tag::TAGS.each do |v|
  Liquid::Template.register_tag v, Jekyll::Assets::Liquid::Tag
end
