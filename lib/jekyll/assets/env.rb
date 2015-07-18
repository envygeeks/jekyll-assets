require_relative "logger"
require_relative "cached"
require "set"

module Jekyll
  module Assets
    class Env < Sprockets::Environment
      attr_reader :jekyll, :used
      include Helpers

      class << self
        attr_accessor :assets_cache, :digest_cache
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
        setup_autoprefixer
        patch_context
        setup_cache
      end

      def all_assets
        out = Set.new(@used)
        out.merge(each_logical_path(*extra_assets).map do |v|
          find_asset(
            v
          )
        end)
      out
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
        the_assets = all_assets
        if !the_assets.any?
          self.class.assets_cache.each do |a|
            if !(n = find_asset(a.logical_path)) || \
                self.class.digest_cache[n.logical_path] == n.digest
              next
            else
              self.class.digest_cache[n.logical_path] = n.digest
              n.write_to(
                as_path(
                  n
                )
              )
            end
          end
        else
          self.class.assets_cache = Set.new(the_assets)
          self.class.digest_cache = Hash[Set.new(the_assets).map do |a|
            [a.logical_path, a.digest]
          end]

          the_assets.each do |v|
            v.write_to(
              as_path(
                v
              )
            )
          end
        end
      end

      private
      def setup_autoprefixer
        if defined?(AutoprefixerRails)
          AutoprefixerRails.install(
            self
          )
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
