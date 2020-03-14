# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Author: Jordon Bedwell
# Encoding: utf-8

require 'sassc'

module Jekyll
  module Assets
    module Patches
      module SassFunctions
        Str = SassC::Script::Value::String

        # --
        # @param path [String] the path.
        # @param options [Hash<String,String>] options.
        # Extracts the asset path, and proxy arguments.
        # @return [SassC::Script::Value::String]
        # @example asset.jpg @path
        # --
        def asset_path(path, options = {})
          path, args = path.value.split(%r!\s+!, 2)
          path, frag = URI.split(path).values_at(5, 8)
          path = sprockets_context.asset_path("#{path} #{args}", options)
          Str.new([path, frag].compact.join("#"))
        end
      end
    end
  end
end

# --
module Sprockets
  class SassProcessor
    module Functions
      prepend Jekyll::Assets::Patches::SassFunctions
    end
  end
end
