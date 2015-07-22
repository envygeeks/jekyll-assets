require_relative "logger"
require_relative "configuration"
require_relative "context"
require_relative "cached"

module Jekyll
  module Assets
    class Env < Sprockets::Environment
      attr_reader :jekyll, :used
      class << self
        attr_accessor :assets_cache, :digest_cache
        def digest_cache
          @_digest_cache ||= {}
        end
      end

      def initialize(path, jekyll = nil)
        jekyll, path = path, nil if path.is_a?(Jekyll::Site)
        @used, @jekyll = Set.new, jekyll
        path ? super(path) : super()
        jekyll.sprockets = self

        merge_config
        set_version
        setup_logger
        append_sources
        setup_css_compressor
        setup_js_compressor
        patch_context
        setup_cache
      end

      # This is normally triggered when you save an asset and the
      # incremental regeneration in Jekyll3 does not trigger that rebuild
      # which means we aren't going to process any liquid which means
      # that you won't get any used assets, which means we need
      # to detect that and then check our caches to determine if
      # we should update any of your assets for you.

      def cached_write?
        !@used.\
          any?
      end

      #

      def all_used_assets
        return Set.new(@used).merge(
          extra_assets
        )
      end

      #

      def all_cached_assets
        return Set.new(self.class.assets_cache).merge(
          extra_assets
        )
      end

      #

      def extra_assets
        each_logical_path(*asset_config.fetch("assets", [])).map do |v|
          find_asset(
            v
          )
        end
      end

      #

      def asset_config
        jekyll.config["assets"] ||= {
          #
        }
      end

      #

      def dev?
        %W(development test).include?(
          Jekyll.env
        )
      end

      #

      def cdn?
        !dev? && !!asset_config[
          "cdn"
        ]
      end

      # There are two ways to enable digesting.  You can 1. be in production
      # or two, you can do the following in your `_config.yml`:
      # ```YAML
      # assets:
      #   digest: true

      def digest?
        !!asset_config[
          "digest"
        ]
      end

      # See: `setup_css_compressor`
      # See: ` setup_js_compressor`

      def compress?(what)
        !!asset_config["compress"][
          what
        ]
      end

      # See: `Cached`

      def cached
        Cached.new(
          self
        )
      end

      # See: `write_cached_assets`
      # See: `write_assets`

      def write_all
        if cached_write?
          then write_cached_assets else write_assets
        end
      end

      # Merge the defaults with your configuration.

      private
      def merge_config(config = nil, merge_into = asset_config)
        config ||= dev?? Configuration::DEVELOPMENT : Configuration::PRODUCTION
        config.each_with_object(merge_into) do |(k, v), h|
          if !h.has_key?(k)
            h[k] = \
              v
          elsif v.is_a?(Hash)
            h[k] = merge_config(
              v, h[k]
            )
          end
        end

        return(
          merge_into
        )
      end

      # If we have used assets then we are working with a brand new
      # build and a brand new set of assets, so we reset the asset_cache
      # and digest_cache and write everything fresh from the start.

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

      # If we do not hae used assets then we assume at that point
      # that we are working with an old cache and that the Jekyll watcher
      # triggered our build and incremental regen already left and
      # ditched out because it had nothing to worry about.
      #
      # At this point we write from the caches, one cache that holds
      # all the previous files we tracked and their digests and then we
      # compare their digests to decide if we rewrite.

      private
      def write_cached_assets
        all_cached_assets.each do |a|
          viejo = self.class.digest_cache[a.logical_path]
          nuevo = find_asset(a.logical_path).digest

          if nuevo == viejo
            logger.debug "Skipping the #{a.logical_path} #{nuevo} == #{
              viejo
            }"

            next
          else
            self.class.digest_cache[a.logical_path] = a.digest
            a.write_to(as_path(
              a
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

      # You can enable compression with:
      # ```YAML
      # assets:
      #   compress:
      #     css: true

      private
      def setup_css_compressor
        if compress?("css")
          self.css_compressor = :sass
        end
      end

      # You can enable compression with:
      # ```YAML
      # assets:
      #   compress:
      #     js: true

      private
      def setup_js_compressor
        if compress?("js")
          Helpers.try_require "uglifier" do
            self.js_compressor = :uglify
          end
        end
      end

      # Bases the version of your assets on the configuration so that if
      # you modify the configuration we can recompile the entire asset chain
      # for you and keep things fresh and clean!

      private
      def set_version
        self.version = Digest::MD5.hexdigest(
          jekyll.config.fetch("assets", {}).to_s
        )
      end

      # SEE: `Context#patch`

      private
      def patch_context
        Context.new(
          context_class
        )
      end

      # Append assets that you always wish to be compiled that aren't
      # ever really called but can be used in other ways:
      # ```YAML
      # assets:
      #   assets:
      #     - "*.jpg"
      #
      # This does not need to be a *, it can be a logical path or
      # probably even a full path... if `find_asset` will accept.

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

      # Pass the logger onto `Jekyll`.
      # See: Logger
      # See: Jekyll

      private
      def setup_logger
        self.logger = Logger.new
      end

      # TODO: Support a configurable asset-cache directory.

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
