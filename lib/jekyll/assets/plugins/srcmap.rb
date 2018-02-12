# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

unless Jekyll::Assets::Utils.old_sprockets?
  require_relative "srcmap/css"
  require_relative "srcmap/javascript"
  require_relative "srcmap/writer"

  module Jekyll
    module Assets
      module Plugins
        module SrcMap
          NAME = "%<name>s.map"
          DIR_NAME = "source-maps"
          DIR = Pathutil.new(DIR_NAME)
          EXT = ".map"

          # --
          # @return [String] the map name.
          # Take the path, and attach the map extension.
          # @note this just saves logic.
          # --
          def self.map_path(env:, asset:)
            [
              path({
                asset: asset,
                env: env,
              }),
              EXT,
            ].join
          end

          # --
          # @note this is used for anything in source-maps.
          # Strip the filename and return a relative sourcemap path.
          # @return [Pathutil] the path.
          # --
          def self.path(env:, asset:)
            DIR.join(env.strip_paths(asset.is_a?(Sprockets::Asset) ?
              asset.filename : asset))
          end
        end
      end
    end
  end
end
