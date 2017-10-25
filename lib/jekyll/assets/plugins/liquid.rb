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
        }

        def self.call(context)
          file = Pathutil.new(context[:filename])
          jekyll = context[:environment].jekyll

          payload_ = jekyll.site_payload
          renderer = jekyll.liquid_renderer.file(file)
          context[:data] = renderer.parse(context[:data]).render!(payload_, {
            :filters => [Jekyll::Filters, Jekyll::Assets::Filters],
            :registers => {
              :site => jekyll
            }
          })
        end
      end


      # --
      # Registers it inside of Sprockets.
      # Because we need to keep some support for 3.x we register it
      #   two different ways depending on the type of Sprockets.
      # --
      if !Env.old_sprockets?
        Liquid::TYPES.each do |k, v|
          to = Utils.strip_secondary_content_type(k)
          Sprockets.register_transformer_suffix to, k,
            ".liquid", Liquid
        end
      else
        # Still the easiest way tbqf.  Never change.
        Sprockets.register_engine '.liquid', Liquid,
          silence_deprecation: true
      end
    end
  end
end
