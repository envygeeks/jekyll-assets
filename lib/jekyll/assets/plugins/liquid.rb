# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Processors
      class Liquid
        EXT = %W(.liquid .js.liquid .css.liquid .scss.liquid).freeze
        FOR = %W(text/css text/sass text/less application/javascript
          text/scss text/coffeescript text/javascript).freeze

        # --

        def self.call(context)
          file = Pathutil.new(context[:filename])
          config = context[:environment].asset_config
          jekyll = context[:environment].jekyll

          if config["features"]["liquid"] || file.extname == ".liquid"
            payload_ = jekyll.site_payload
            renderer = jekyll.liquid_renderer.file(file)
            context[:data] = renderer.parse(context[:data]).render!(payload_, {
              :filters => [Jekyll::Filters],
              :registers => {
                :site => jekyll
              }
            })
          end
        end
      end
    end
  end
end

# --
# There might be a few missing, if there is please do let me know.
# --
# Jekyll::Assets::Processors::Liquid::EXT.each do |ext|
#   Sprockets.register_engine(ext, Jekyll::Assets::Processors::Liquid, {
#     :silence_deprecation => true
#   })
# end

# --
# Jekyll::Assets::Processors::Liquid::FOR.each do |v|
#   Sprockets.register_preprocessor(v, Jekyll::Assets::Processors::Liquid)
# end
