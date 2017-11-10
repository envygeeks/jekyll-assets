# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "pathutil"
require_relative "../utils"
require "jekyll/assets"
require "jekyll"

module Jekyll
  module Assets
    module Plugins
      class Liquid
        TYPES = {
          "application/liquid+javascript" =>  ".liquid.js",
          "text/liquid+sass" => %w(.css.liquid.sass .liquid.sass),
          "text/liquid+coffeescript" => %w(.js.liquid.coffee .liquid.coffee),
          "application/ecmascript-6" => %w(.js.liquid.es6 .liquid.es6),
          "text/liquid+scss" => %w(.css.liquid.scss .liquid.scss),
          "text/liquid+css" => ".liquid.css",
        }.freeze

        def self.call(ctx)
          env = ctx[:environment]
          bctx = ::Liquid::Context.new({}, {}, site: env.jekyll)
          ctx[:data] = env.parse_liquid(ctx[:data], {
            ctx: bctx,
          })
        end
      end

      # --
      # Registers it inside of Sprockets.
      # Because we need to keep some support for 3.x we register it
      #   two different ways depending on the type of Sprockets.
      # --
      if !Env.old_sprockets?
        Liquid::TYPES.each_key do |k|
          to = Utils.strip_secondary_content_type(k)
          Sprockets.register_transformer_suffix to, k,
            ".liquid", Liquid
        end
      else
        # Still the easiest way tbqf.  Never change.
        Sprockets.register_engine ".liquid", Liquid,
          silence_deprecation: true
      end
    end
  end
end
