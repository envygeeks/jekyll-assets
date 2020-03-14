# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

module Jekyll
  module Assets
    module Filters
      def asset(path, args = "")
        args = "#{path} #{args}"
        ctx = Liquid::ParseContext.new
        tag = Tag.new("asset", args, ctx)
        tag.render(@context)
      end

      # --
      # Register the filter
      # @see `jekyll/assets.rb`
      # @return [nil]
      # --
      def self.register
        Liquid::Template.register_filter(self)
      end
    end
  end
end
