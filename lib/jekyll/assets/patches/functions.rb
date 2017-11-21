# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Patches
      module SassFunctions
        def asset_path(path, options = {})
          path, args = path.value.split(%r!\s+!, 2)
          path, = URI.split(path)[5..8]
          path = "#{path} #{args}"

          # We strip the query string, and the fragment.
          path = sprockets_context.asset_path(path, options)
          Sprockets::Autoload::Sass::Script::String.new \
            path, :string
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
