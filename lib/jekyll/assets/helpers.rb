# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Helpers

      # --
      # asset_path will find the path to the asset.
      # @todo this needs to be using `asset` once tag is changed.
      # @param [String] path the path you wish to resolve.
      # @param [Hash] opts, the opts.
      # @return [String]
      # --
      def asset_path(path, opts = {})
        Tag.new("img", "#{path} @path", Context.new).render(context)
      end

      # --
      # @param [Hash] opts the opts
      # @param [String] path the path you wish to resolve
      # Pull the asset path and wrap it in url().
      # @return [String]
      # --
      def asset_url(path, **kwd)
        return "url(#{
          asset_path(path, **kwd)
        })"
      end

      # --
      private
      def context
        @struct ||= Struct.new(:registers)
        @struct.new({
          :site => env.jekyll
        })
      end
    end
  end
end

#

module Sprockets
  class Context
    prepend Jekyll::Assets::Helpers
    alias_method :env, :environment
  end
end
