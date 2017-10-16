# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "pathutil"
require "jekyll/assets"
require "jekyll"

module Jekyll
  module Assets
    module Plugins
      class Liquid
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
    end
  end
end

args = %w(application/\2+liquid .liquid) << Jekyll::Assets::Plugins::Liquid
Sprockets.register_transformer_suffix "text/sass", *args
Sprockets.register_transformer_suffix "text/scss", *args
Jekyll::Assets::Env.register_ext_map ".css.liquid", ".css"
Jekyll::Assets::Env.register_ext_map ".sass.liquid", ".css"
Jekyll::Assets::Env.register_ext_map ".js.coffee.liquid", ".js"
Jekyll::Assets::Env.register_ext_map ".css.sass.liquid", ".css"
Sprockets.register_transformer_suffix "application/javascript", *args
Sprockets.register_transformer_suffix "application/ecmascript-6", *args
Sprockets.register_transformer_suffix "text/coffeescript", *args
Jekyll::Assets::Env.register_ext_map ".css.scss.liquid", ".css"
Jekyll::Assets::Env.register_ext_map ".coffee.liquid", ".js"
Jekyll::Assets::Env.register_ext_map ".scss.liquid", ".css"
Jekyll::Assets::Env.register_ext_map ".es6.liquid", ".js"
Sprockets.register_transformer_suffix "text/css", *args
Jekyll::Assets::Env.register_ext_map ".js.liquid", ".js"
