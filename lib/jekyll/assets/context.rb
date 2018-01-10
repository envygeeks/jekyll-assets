# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require_relative "context"
require_relative "tag"

# --
module Jekyll
  module Assets
    module Context
      # --
      # Allows you to get an asset by it's path.
      # @note this SASS helper fully supports proxy arguments.
      # @param [Hash] opts this is unused but necessary.
      # @param [String] path the path.
      # @return [String] the path.
      # --
      def asset_path(path, _ = {})
        ctx1 = Liquid::ParseContext.new
        ctx2 = Liquid::Context.new({}, {}, site: environment.jekyll)
        Jekyll::Assets::Tag.new("img", "#{path} @path", ctx1)
          .render(ctx2)
      end
    end
  end
end

# --
Jekyll::Assets::Hook.register(:env, :after_init) do
  context_class.send(:include, Jekyll::Assets::Context)
end
