# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "jekyll"

module Jekyll
  module Assets
    module Plugins
      class FrontMatter
        REGEXP = Jekyll::Document::YAML_FRONT_MATTER_REGEXP
        def call(input)
          {
            data: input[:data].gsub(REGEXP, ""),
          }
        end
      end
    end
  end
end

processor = Jekyll::Assets::Plugins::FrontMatter.new
Sprockets.register_preprocessor "text/sass", processor
Sprockets.register_preprocessor "application/javascript", processor
Sprockets.register_preprocessor "application/ecmascript-6", processor
Sprockets.register_preprocessor "text/coffeescript", processor
Sprockets.register_preprocessor "text/scss", processor
Sprockets.register_preprocessor "text/css", processor
