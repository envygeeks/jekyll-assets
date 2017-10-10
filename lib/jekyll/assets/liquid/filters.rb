# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Liquid
      module Filters
        def asset(path, args = "")
          args = "#{path} #{args}"
          context = ParseContext.new
          tag = Tag.new(val, args, context)
          tag.render(@context)
        end
      end
    end
  end
end

filter = Jekyll::Assets::Liquid::Filters
Liquid::Template.register_filter(filter)
