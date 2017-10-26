# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require_relative "map/css"
require_relative "map/javascript"
require_relative "map/writer"
require "pathutil"

module Jekyll
  module Assets
    module Map
      NAME = "%s.map".freeze
      DIR_NAME = "source-maps".freeze
      DIR = Pathutil.new(DIR_NAME)
      EXT = ".map".freeze

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
