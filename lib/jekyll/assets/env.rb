# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "pathutil"
require "forwardable/extended"
require "jekyll/sanity"
require "sprockets"
require "jekyll"

require_all "patches/*"
require_relative "utils"
require_relative "drop"
require_relative "filters"
require_relative "manifest"
require_relative "config"
require_relative "logger"
require_relative "utils"
require_relative "hook"
require_relative "tag"

module Jekyll
  module Assets
    class Env < Sprockets::Environment
      extend Forwardable::Extended
      include Utils

      # --
      attr_reader :manifest
      attr_reader :asset_config
      attr_reader :jekyll

      # --
      def initialize(jekyll = nil)
        @asset_config = Config.new(jekyll.config["assets"] ||= {})
        Logger.debug "Callings hooks for env, before_init" do
          Hook.trigger :env, :before_init do |h|
            instance_eval(&h)
          end
        end

        super()
        @jekyll = jekyll
        @manifest = Manifest.new(self, in_dest_dir)
        @jekyll.sprockets = self
        @logger = Logger
        @cache = nil

        excludes!
        disable_erb!
        enable_compression!
        setup_sources!
        setup_drops!
        precompile!

        Logger.debug "Calling hooks for env, after_init" do
          Hook.trigger :env, :after_init do |h|
            instance_eval(&h)
          end
        end
      end

      # --
      # @note this is configurable with :caching -> :type
      # Create a cache, or a null cache (if no caching) for caching.
      # @note this is configurable with :caching -> :enabled
      # @return [Sprockets::Cache]
      # --
      def cache
        @cache ||= begin
          type = asset_config[:caching][:type]
          enabled = asset_config[:caching][:enabled]
          path = in_cache_dir

          out = Sprockets::Cache::MemoryStore.new if enabled && type == "memory"
          out = Sprockets::Cache::FileStore.new(path) if enabled && type == "file"
          out = Sprockets::Cache::NullStore.new unless enabled
          Sprockets::Cache.new(out, Logger)
        end
      end

      # --
      # @note this does not find the asset.
      # Takes all user assets and turns them into a drop.
      # @return [Hash]
      # --
      def to_liquid_payload
        each_file.each_with_object({}) do |k, h|
          skip, path = false, Pathutil.new(strip_paths(k))
          path.descend do |p|
            skip = p.start_with?("_")
            if skip
              break
            end
          end

          next if skip
          h.update({
            path.to_s => Drop.new(path, {
              jekyll: jekyll,
            }),
          })
        end
      end

      # --
      def self.old_sprockets?
        @old_sprockets ||= begin
          Gem::Version.new(Sprockets::VERSION) < Gem::Version.new("4.0.beta")
        end
      end

      # --
      private
      def excludes!
        excludes = Config.defaults[:sources]
        jekyll.config["exclude"].concat(excludes)
        jekyll.config["exclude"] << in_cache_dir.sub(jekyll.in_source_dir + "/", "")
        jekyll.config["exclude"].uniq!
      end

      # --
      private
      def enable_compression!
        return unless asset_config[:compression]
        source_map = Jekyll.dev? && !self.class.old_sprockets?
        self. js_compressor = (source_map ? :source_map : :uglify)
        self.css_compressor = (source_map ? :source_map : :scss)

        nil
      end

      # --
      private
      def precompile!
        assets = asset_config[:precompile]
        assets.map do |v|
          compile(v)
        end

        nil
      end

      # --
      private
      def disable_erb!
        return unless jekyll.safe
        @config = hash_reassoc @config, :registered_transformers do |o|
          o.delete_if do |v|
            v.proc == Sprockets::ERBProcessor
          end
        end
      end

      # --
      private
      def setup_sources!
        @sources ||= begin
          asset_config["sources"].each do |v|
            unless paths.include?(jekyll.in_source_dir(v))
              append_path jekyll.in_source_dir(v)
            end
          end

          paths
        end
      end

      # --
      private
      def setup_drops!
        Jekyll::Hooks.register :site, :pre_render do |_, h|
          h["assets"] = to_liquid_payload
        end
      end

      require_all "plugins/*"
      require_all "plugins/html/defaults/*"
      require_all "plugins/html/*"
      unless old_sprockets?
        require_relative "map"
      end
    end
  end
end
