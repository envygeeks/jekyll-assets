# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "pathutil"
require "forwardable/extended"
require "jekyll/sanity"
require "sprockets"
require "jekyll"

require_all "patches/*"
require_relative "utils"
require_relative "drop"
require_relative "version"
require_relative "filters"
require_relative "manifest"
require_relative "writer"
require_relative "reader"
require_relative "config"
require_relative "logger"
require_relative "hook"
require_relative "tag"
require_relative "url"

module Jekyll
  module Assets
    class Env < Sprockets::Environment
      extend Forwardable::Extended
      include Utils

      # --
      attr_reader :manifest
      attr_accessor :assets_to_write
      attr_reader :asset_config
      attr_reader :jekyll

      # --
      rb_delegate :old?, to: :"self.class"
      rb_delegate :old_sprockets?, {
        to: :"self.class",
      }

      # --
      def initialize(jekyll = nil)
        @asset_config = Config.new(jekyll.config["assets"] ||= {})
        Hook.trigger :env, :before_init do |h|
          instance_eval(&h)
        end

        super()
        @jekyll = jekyll
        @assets_to_write = []
        @manifest = Manifest.new(self, in_dest_dir)
        @jekyll.sprockets = self
        @total_time = 0.000000
        @logger = Logger
        @cache = nil

        setup_sources!
        enable_compression!
        ignore_caches!
        setup_drops!
        precompile!
        copy_raw!

        Hook.trigger :env, :after_init do |h|
          instance_eval(&h)
        end
      end

      # --
      def skip_gzip?
        !asset_config[:gzip]
      end

      # --
      def find_asset(v, *a)
        msg = "Searched for, and rendered #{v} in %<time>s"
        out = Logger.with_timed_logging msg do
          super(v, *a)
        end

        # We keep track.
        @total_time += out[:time]
        out[:result]
      end

      # --
      def find_asset!(v, *a)
        msg = "Searched for, and rendered #{v} in %<time>s"
        out = Logger.with_timed_logging msg do
          super(v, *a)
        end

        # We keep track.
        @total_time += out[:time]
        out[:result]
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
          enbl = asset_config[:caching][:enabled]
          path = in_cache_dir

          out = Sprockets::Cache::MemoryStore.new if enbl && type == "memory"
          out = Sprockets::Cache::FileStore.new(path) if enbl && type == "file"
          out = Sprockets::Cache::NullStore.new unless enbl
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
      class << self
        alias old? old_sprockets?
      end

      # --
      def write_all
        remove_old_assets unless asset_config[:digest]
        manifest.compile(*assets_to_write); @asset_to_write = []
        Hook.trigger(:env, :after_write) { |h| instance_eval(&h) }
        Logger.debug "took #{format(@total_time.round(2).to_s,
          '%.2f')}s"
      end

      # ---
      def remove_old_assets
        assets_to_write.each do |v|
          in_dest_dir(find_asset!(v).logical_path).rm_f
        end
      end

      # --
      private
      def ignore_caches!
        jekyll.config["exclude"] ||= []
        jekyll.config["exclude"].push(asset_config[:caching][:path])
        jekyll.config["exclude"].uniq!
      end

      # --
      private
      def enable_compression!
        self.js_compressor, self.css_compressor = nil, nil

        return unless asset_config[:compression]
        config = asset_config[:compressors][:uglifier].symbolize_keys
        self. js_compressor = Sprockets::UglifierCompressor.new(config)
        Utils.activate("sassc") { self.css_compressor = :scssc } unless old?
        self.css_compressor ||= :scss
      end

      # --
      def copy_raw!
        raw_precompiles.each do |v|
          v[:dst].mkdir_p if v[:dst].extname.empty?
          v[:dst].parent.mkdir_p unless v[:dst].extname.empty?
          v[:src].cp(v[:dst])
        end
      end

      # --
      private
      def precompile!
        assets = asset_config[:precompile]
        assets.map do |v|
          v !~ %r!\*! ? @assets_to_write |= [v] : glob_paths(v).each do |sv|
            @assets_to_write |= [sv]
          end
        end

        nil
      end

      # --
      private
      def setup_sources!
        source_dir, cwd = Pathutil.new(jekyll.in_source_dir), Pathutil.cwd
        asset_config["sources"].each do |v|
          path = source_dir.join(v).expand_path
          next unless path.in_path?(cwd)
          unless paths.include?(path)
            append_path path
          end
        end

        paths
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
      require_relative "context"

      require_relative "map" unless old_sprockets?
      Hook.register :env, :after_init, priority: 3 do
        unless old?
          Map.register_on(self)
        end
      end

      # --
      # @see https://github.com/rails/sprockets/pull/523
      # Registers a few MimeTypes since I don't think
      #   Sprockets will update before we release, so we
      #   need them to be available.
      # --
      Sprockets.register_mime_type "audio/mp4", extensions: %w(.m4a)
      Sprockets.register_mime_type "audio/ogg", extensions: %w(.ogg .oga)
      Sprockets.register_mime_type "audio/flac", extensions: %w(.flac)
      Sprockets.register_mime_type "audio/aac", extensions: %w(.aac)
    end
  end
end
