# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    module Patches
      module SassFunctions
        Str = ::Sprockets::Autoload::Sass::Script::String

        # --
        # @param path [String] the path.
        # @param opts [Hash<String,String>] options.
        # Extracts the asset path, and proxy arguments.
        # @example asset.jpg @path
        # @return [String]
        # --
        def asset_path(path, options = {})
          path, args = path.value.split(%r!\s+!, 2)
          path, fragment = URI.split(path).values_at(5, 8)
          path = sprockets_context.asset_path("#{path} #{args}", options)
          Str.new [path, fragment].compact.join("#")
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
