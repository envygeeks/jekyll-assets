# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Patches
      module SassFunctions
        SprocketsString = ::Sprockets::Autoload::Sass::Script::String

        def asset_path(path, options = {})
          path, args = path.value.split(%r!\s+!, 2)
          path, fragment = URI.split(path).values_at(5, 8)
          path = sprockets_context.asset_path("#{path} #{args}", options)
          SprocketsString.new [path, fragment].compact.join("#")
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
