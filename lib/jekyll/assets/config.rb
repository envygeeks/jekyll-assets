# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    class Config < HashWithIndifferentAccess
      Hook.add_point :env, :before_merge
      DIRECTORIES = %i(
        css fonts images
        videos audios components
        javascript video audio
        image img js
      ).freeze

      #
      # The source directories
      # @note _assets, assets, and base
      # @return [Array<String>]
      #
      def self.sources
        return @sources if defined?(@sources)

        sources_a = []
        sources_b = []
        sources_c = []

        DIRECTORIES.map do |name|
          sources_a.push(format('assets/%<name>s', name: name))
          sources_b.push(name.to_s)
          sources_c.push(
            format(
              '_assets/%<name>s', {
                name: name
              }
            )
          )
        end

        @sources = \
          sources_a |
          sources_b |
          sources_c
      end

      def self.development
        return @development if defined?(@development)
        @development = {
          digest: true,
          precompile: [],
          source_maps: true,
          destination: '/assets',
          compression: false,
          raw_precompile: [],
          sources: sources,
          full_url: false,
          defaults: {},
          gzip: false,

          compressors: {
            uglifier: {
              comments: false,
              harmony: true,
            },
          },

          caching: {
            path: '.jekyll-cache/assets',
            enabled: true,
            type: 'file',
          },

          cdn: {
            baseurl: false,
            destination: false,
            url: nil,
          }
        }
      end

      def self.production
        return @production if defined?(@production)
        @production = @development.merge(
          source_maps: false,
          compression: true
        )
      end

      def self.defaults
        return development if Jekyll.dev?
        production
      end

      def initialize(config)
        super(self.class.defaults)
        Hook.trigger(:config, :before_merge) do |h|
          h.call(
            self
          )
        end

        deep_merge!(config)
        self[:sources] = \
          Array(self[:sources]) |
          self.class.defaults[
            :sources
          ]
      end
    end
  end
end
