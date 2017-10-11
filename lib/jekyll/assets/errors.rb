# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Errors
      class AssetNotFound < StandardError
        def initialize(path, context = nil)
          base = "unable to find the asset #{path}"

          if context
            path = context.registers[:site].sprockets.paths.join("\n  ")
            page = context.registers[:page]["path"]
            super "#{base} in #{page} \n looked " \
              "in: \n  #{path}"
          else
            super base
          end
        end
      end
    end
  end
end
