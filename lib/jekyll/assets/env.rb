# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require_relative "reader"

dir = Pathutil.new(__dir__)
dir.join("compressors").children do |v|
  unless v.directory?
    require v
  end
end

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
        ignore_caches!
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
        @cache ||= Cache.new({
          manifest: manifest,
          config: asset_config,
          dir: in_cache_dir,
        })
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
          h[path.to_s] = Drop.new(path, {
            jekyll: jekyll,
          })
        end
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

      require_relative "plugins"
      require_relative "context"
    end
  end
end
