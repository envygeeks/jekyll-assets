# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Helpers
      def asset_path(path, opts = {})
        Tag.new("img", "#{path} @path", Context.new).render(context)
      end

      def asset_url(path, **kwd)
        return "url(#{
          asset_path(path, **kwd)
        })"
      end

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
