# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require_relative "context"
require_relative "tag"

module Jekyll
  module Assets
    module Filters
      def asset(path, args = "")
        args = "#{path} #{args}"
        ctx = Liquid::ParseContext.new
        tag = Tag.new("asset", args, ctx)
        tag.render(@context)
      end
    end
  end
end

filter = Jekyll::Assets::Filters
Liquid::Template.register_filter(filter)
