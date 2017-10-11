# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

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

# This is super huge, but what can you do? They do it different than I do.
Sprockets.register_transformer_suffix(%w(application/ecmascript-6
application/javascript text/coffeescript text/css text/sass text/scss),
'application/\2+liquid', '.liquid', Jekyll::Assets::Plugins::Liquid)
