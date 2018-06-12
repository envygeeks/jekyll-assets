# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    class Config < HashWithIndifferentAccess

      # --
      # Register Hooks.
      # @note (before)_merge
      # @return [nil]
      # --
      %i(before).map do |v|
        Hook.add_point :env, :"#{v}_merge"
      end

      # --
      DEVELOPMENT = {
        digest: true,
        precompile: [],
        source_maps: true,
        destination: "/assets",
        compression: false,
        raw_precompile: [],
        defaults: {},
        gzip: false,

        compressors: {
          uglifier: {
            comments: false,
            harmony: true,
          },
        },

        caching: {
          path: ".jekyll-cache/assets",
          enabled: true,
          type: "file",
        },

        cdn: {
          baseurl: false,
          destination: false,
          url: nil,
        },

        sources: %w(
          assets/css
          assets/fonts
          assets/images
          assets/videos
          assets/audios
          assets/components
          assets/javascript
          assets/video
          assets/audio
          assets/image
          assets/img
          assets/js

          _assets/css
          _assets/fonts
          _assets/images
          _assets/videos
          _assets/audios
          _assets/components
          _assets/javascript
          _assets/video
          _assets/audio
          _assets/image
          _assets/img
          _assets/js

          css
          fonts
          images
          videos
          audios
          components
          javascript
          audio
          video
          image
          img
          js
        ),
      }.freeze

      # --
      PRODUCTION = DEVELOPMENT.deep_merge({
        source_maps: false,
        compression: true,
      }).freeze

      # --
      def initialize(config)
        super(self.class.defaults)
        Hook.trigger(:config, :before_merge) { |h| h.call(self) }
        deep_merge!(config)
        merge_sources!
      end

      # --
      # @return [HashWithIndifferentAccess]
      # @note this is useful if you are in safe mode.
      # The original defaults we have set.
      # --
      def self.defaults
        Jekyll.dev? ? DEVELOPMENT : PRODUCTION
      end

      # --
      # Merge our sources with their sources.
      # @note we don't really allow users to remove our sources.
      # @return [nil]
      # --
      private
      def merge_sources!
        ours = self.class.defaults[:sources]
        theirs = [self[:sources] || []].flatten.compact
        self[:sources] = theirs | ours
      end
    end
  end
end
