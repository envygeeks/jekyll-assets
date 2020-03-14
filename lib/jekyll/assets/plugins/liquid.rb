# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    module Plugins
      class Liquid
        TYPES = {
          "text/liquid+sass" => %w(.sass.liquid .liquid.sass),
          "application/liquid+javascript" =>  %w(.liquid.js .js.liquid),
          "application/liquid+ecmascript-6" => %w(.liquid.es6 .es6.liquid),
          "text/liquid+coffeescript" => %w(.liquid.coffee .coffee.liquid),
          "text/liquid+scss" => %w(.liquid.scss .scss.liquid),
          "text/liquid+css" => %w(.liquid.css .css.liquid),
          "image/liquid+svg+xml" => %w(.liquid.svg .svg.liquid),
        }.freeze

        def self.call(ctx)
          env = ctx[:environment]
          registers = { site: env.jekyll }
          environment = env.jekyll.to_liquid.merge(jekyll: {
            "version" => Jekyll::VERSION, "environment" => Jekyll.env
          })

          bctx = ::Liquid::Context.new(environment, {}, registers)
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
      Liquid::TYPES.each do |k, v|
        to = Utils.strip_secondary_content_type(k)
        charset = Sprockets.mime_types[to][:charset]
        Sprockets.register_mime_type(k, extensions: v, charset: charset)
        Sprockets.register_transformer(k, to, Liquid)
      end
    end
  end
end
