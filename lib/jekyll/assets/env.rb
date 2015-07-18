require_relative "logger"
require_relative "cached"

module Jekyll
  module Assets
    class Env < Sprockets::Environment
      attr_reader :jekyll, :used
      include Helpers
      HOOK_POINTS = [
        :pre_init, :post_init
      ]

      class UnknownHookPointError < RuntimeError
        def initialize(point)
          super "Unknown jekyll-assets hook point (#{point}) given."
        end
      end

      class << self
        attr_accessor :assets_cache, :digest_cache
        def hooks
          @_hooks ||= {
            #
          }
        end

        def trigger_hooks(point, *args)
          if hooks[point]
            then hooks[point].map do |v|
              v.call(
                *args
              )
            end
          end
        end

        def register_hook(point, &block)
          if HOOK_POINTS.include?(point)
            (hooks[point] ||= Set.new) << \
              block
          else
            raise(
              UnknownHookPointError, point
            )
          end
        end
      end

      def initialize(path, jekyll = nil)
        jekyll, path = path, nil if path.is_a?(Jekyll::Site)
        @used, @jekyll = Set.new, jekyll
        path ? super(path) : super()
        jekyll.sprockets = self

        set_version
        setup_logger
        append_sources
        setup_css_compressor
        setup_js_compressor
        patch_context
        setup_cache
      end

      def cached_write?
        !@used.\
          any?
      end

      def all_used_assets
        return Set.new(@used).merge(
          extra_logical_paths
        )
      end

      def all_cached_assets
        return Set.new(self.class.assets_cache).merge(
          extra_logical_paths
        )
      end

      def extra_logical_paths
        each_logical_path(*extra_assets).map do |v|
          find_asset(
            v
          )
        end
      end

      def extra_assets
        asset_config.fetch(
          "assets", []
        )
      end

      def asset_config
        jekyll.config.fetch(
          "assets", {}
        )
      end

      def digest?
        !%W(development test).include?(Jekyll.env) || \
        asset_config.fetch(
          "digest", false
        )
      end

      def compress?(what)
        !%W(development test).include?(Jekyll.env) || \
        asset_config.fetch("compress", {}).fetch(
          what, false
        )
      end

      def cached
        Cached.new(
          self
        )
      end

      def write_all
        if cached_write?
          then write_cached_assets else write_assets
        end
      end

      private
      def write_assets(assets = self.all_used_assets)
        self.class.assets_cache = Set.new(assets)
        self.class.digest_cache = Hash[Set.new(assets).map do |a|
          [a.logical_path, a.digest]
        end]

        assets.each do |v|
          v.write_to(
            as_path(
              v
            )
          )
        end
      end

      private
      def write_cached_assets
        all_cached_assets.each do |a, n = find_asset(a.logical_path)|
          if !n || self.class.digest_cache[n.logical_path] == n.digest
            then next
          else
            self.class.digest_cache[n.logical_path] = n.digest
            n.write_to(as_path(
              n
            ))
          end
        end
      end

      private
      def as_path(v)
        jekyll.in_dest_dir(File.join(
          asset_config.fetch("prefix", "/assets"), (
            digest?? v.digest_path : v.logical_path
          )
        ))
      end

      private
      def setup_css_compressor
        if compress?("css")
          self.css_compressor = :sass
        end
      end

      private
      def setup_js_compressor
        if compress?("js")
          self.js_compressor = :uglify
        end
      end

      private
      def set_version
        self.version = Digest::MD5.hexdigest(
          jekyll.config.fetch("assets", {}).to_s
        )
      end

      # -----------------------------------------------------------------------
      # TODO: Move this into it's own file and patch Sprocket::Context
      # -----------------------------------------------------------------------

      private
      def patch_context
        context_class.class_eval do
          alias_method :_old_asset_path, :asset_path
          def asset_path(asset, opts = {})
            out = _old_asset_path(
              asset, opts = {}
            )

            if out
              environment.parent.used.add(
                environment.find_asset(
                  resolve(asset)
                )
              )
            end
          out
          end
        end
      end

      private
      def append_sources
        if asset_config.fetch("sources", nil)
          then sources = asset_config[
            "sources"
          ]
        else
          sources = %W(
            _assets/css
            _assets/fonts
            _assets/img
            _assets/js
          )
        end

        sources.each do |v|
          append_path(
            jekyll.in_source_dir(v)
          )
        end
      end

      private
      def setup_logger
        self.logger = Logger.new
      end

      # -----------------------------------------------------------------------
      # TODO: Support a configurable asset-cache directory.
      # -----------------------------------------------------------------------

      private
      def setup_cache
        self.cache = Sprockets::Cache::FileStore.new(
          jekyll.in_source_dir(
            ".asset-cache"
          )
        )
      end
    end
  end
end
