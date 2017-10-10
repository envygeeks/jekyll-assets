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
        prefix: "/assets",
        strict: false,
        digest: false,
        integrity: false,
        autowrite: true,
        liquid: false,

        caching: {
          enabled: true,
          path: ".jekyll-cache/assets",
          type: "file",
        },

        precompile: [
          #
        ],

        cdn: {
          baseurl: false,
          prefix: false,
        },

        plugins: {
          img: {
            optim: {
              #
            },
          },

          compression: {
            js: {
              enabled: true,
              opts: {
                #
              }
            },

            css: {
              enabled: true,
            }
          }
        },

        sources: %W(
          _assets/css
          _assets/fonts
          _assets/img
          _assets/js
        )
      }.freeze

      # --
      PRODUCTION = DEVELOPMENT.deep_merge({
        digest: true,
        compress: {
          css: true,
          js: true,
        }
      }).freeze

      # --
      # @param [Hash] config the configuration
      # intitialize creates a new HashWithIndifferentAccess
      # @return [Config]
      # --
      def initialize(config)
        super(defaults.deep_merge(config))
        s1 = [self[:sources] || []].flatten.compact
        s2 = defaults[:sources]
        self[:sources] =
          s1 + s2
      end

      # --
      # @note this is for safemode usage.
      # defaults provides the configuration defaults
      # @return [Hash]
      # --
      def defaults
        if Jekyll.env == "production"
          return PRODUCTION
        end

        DEVELOPMENT
      end
    end
  end
end
