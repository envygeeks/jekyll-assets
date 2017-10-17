# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require_relative "context"
require_relative "tag"

module Jekyll
  module Assets
    module Filters
      def asset(path, args = "")
        context = Context.new
        args = "#{path} #{args}"
        tag = Tag.new(val, args, context)
        tag.render(@context)
      end
    end
  end
end

filter = Jekyll::Assets::Filters
Liquid::Template.register_filter(filter)
