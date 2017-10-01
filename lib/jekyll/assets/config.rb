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
        liquid: false,
        digest: false,
        prefix: "/assets",
        integrity: false,
        autowrite: true,

        precompile: [
          #
        ],

        cdn: {
          baseurl: false,
          prefix: false,
        },

        cache: {
          enabled: true,
          path: ".jekyll-cache/assets",
          type: "file",
        },

        compress: {
          css: false,
          js: false,
        },

        plugins: {
          img: {
            optim: {
              #
            },

            defaults: {
              dimensions: true,
              alt: true,
            }
          }
        },

        sources: %W(
          _assets/css
          _assets/fonts
          _assets/stylesheets
          _assets/javascripts
          _assets/images
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
      # @param [Hash] config the Jekyll#Site.configuration
      # intitialize creates a new HashWithIndifferentAccess so
      # that you can access the configuration without the
      # need to worry about `String` vs `Symbol`
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
      # defaults provides the configuration defaults, his exists
      # so that plugins can get hold of the preferred defaults in the
      # even of being thrown into SafeMode.
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
