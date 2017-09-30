# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Config
      DefaultSources = %W(
        _assets/css _assets/stylesheets
        _assets/images _assets/img _assets/fonts
        _assets/javascripts _assets/js
      ).freeze

      # --
      Development = {
        "liquid"    => false,
        "digest"    => false,
        "prefix"    => "/assets",
        "integrity" => false,
        "autowrite" => true,
        "sources"   => [],
        "assets"    => [],

        "img" => {
          "dimensions" => true,
          "alt"        => true,
        },

        "cdn" => {
          "baseurl" => false,
          "prefix"  => false,
        },

        "cache" => {
          "enabled" => true,
          "path"    => ".jekyll-cache/assets",
          "type"    => "file",
        },

        "compress" => {
          "css" => false,
          "js"  => false,
        },

        "image_optim" => {}
      }.freeze

      # --
      Production = Development.merge({
        "digest"   => true,
        "compress" => {
          "css" => true,
          "js"  => true
        }
      }).freeze

      # --
      # @param [Jekyll::Site] jekyll The jekyll instance.
      # @param [Hash<{}>] config the configuration to alter.
      # Merge our sources with Jekyll's sources.
      # --
      def self.merge_sources(jekyll, config) config["sources"] ||= []
        if !config["sources"].grep(/\A\s*_assets\/?\s*\Z/).empty?
          return

        else
          sources = DefaultSources + config["sources"].to_a
          config["sources"] = Set.new(sources.map do |val|
            jekyll.in_source_dir(val)
          end)
        end
      end

      # --
      # @note normally you wouldn't be using the defaults but
      #   they exist so that if you have something that should
      #   not be customizable in `#safe?` then you can refer
      #   to the defaults we prefer, or that you prefer if
      #   you add your defaults to the configuration.
      # --
      def self.defaults
        %W(development test).include?(Jekyll.env) ? Development : Production
      end

      # --
      def self.merge(new_hash, old_hash = defaults)
        old_hash.merge(new_hash) do |_, old_val, new_val|
          old_val.is_a?(Hash) && new_val.is_a?(Hash) ?
            merge(new_val, old_val) : new_val
        end
      end
    end
  end
end
