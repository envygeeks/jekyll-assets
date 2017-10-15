# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "active_support/hash_with_indifferent_access"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/hash/deep_merge"

module Jekyll
  module Assets
    class Config < HashWithIndifferentAccess
      DEVELOPMENT = {
        source_maps: true,
        subresource_integrity: false,
        save_directory: "/assets",
        compression: true,
        digest: false,

        caching: {
          enabled: true,
          path: ".jekyll-cache/assets",
          type: "file",
        },

        precompile: [
          #
        ],

        cdn: {
          save_directory: false,
          jekyll_baseurl: false,
        },

        sources: %W(
          assets/css
          assets/fonts
          assets/images
          assets/javascript
          assets/image
          assets/img
          assets/js

          _assets/css
          _assets/fonts
          _assets/images
          _assets/javascript
          _assets/image
          _assets/img
          _assets/js

          css
          fonts
          images
          javascript
          image
          img
          js
        )
      }.freeze

      PRODUCTION = DEVELOPMENT.deep_merge({
        source_maps: false
      }).freeze

      def initialize(config)
        super(self.class.defaults)
        Hook.trigger :config, :pre do |h|
          h.call(self)
        end

        deep_merge!(config)
        s1 = [self[:sources] || []].flatten.compact
        s2 = self.class.defaults[:sources]
        self[:sources] =
          s1 + s2
      end

      def self.defaults
        if Jekyll.env == "production"
          return PRODUCTION
        end

        DEVELOPMENT
      end
    end
  end
end
