# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require_relative "context"
require_relative "tag"

module Jekyll
  module Assets
    module Helpers

      # --
      # Allows you to get an asset by it's path.
      # @note this SASS helper fully supports proxy arguments.
      # @param [Hash] opts this is unused but necessary.
      # @param [String] path the path.
      # @return [String] the path.
      # --
      def asset_path(path, _opts = {})
        Tag.new("img", "#{path} @path", Context
          .new).render(context)
      end

      # --
      # Allows you to get the asset by it's path.
      # @note this SASS helper fully supports proxy arguments.
      # @return [String] the path wrapped in `url()`
      # @param [String] path the path.
      # --
      def asset_url(path, **kwd)
        return "url(#{asset_path(path, **kwd)})"
      end

      # --
      private
      def context
        @struct ||= Struct.new(:registers)
        @struct.new({
          :site => environment.jekyll
        })
      end
    end
  end
end

#

module Sprockets
  class Context
    prepend Jekyll::Assets::Helpers
  end
end
