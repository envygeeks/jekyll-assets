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

        Hook.trigger :env, :post_init, self
      end

      # This is normally triggered when you save an asset and the
      # incremental regeneration in Jekyll3 does not trigger that rebuild
      # which means we aren't going to process any liquid which means
      # that you won't get any used assets, which means we need
      # to detect that and then check our caches to determine if
      # we should update any of your assets for you.

      def cached_write?
        !@used.any?
      end

      # XXX: Doc

      def all_used_assets
        return Set.new(@used).merge extra_assets
      end

      # XXX: Doc

      def all_cached_assets
        return Set.new(self.class.assets_cache).merge extra_assets
      end

      # XXX: Doc

      def extra_assets
        each_logical_path(*asset_config.fetch("assets", [])).map do |v|
          find_asset v
        end
      end

      # XXX: Doc

      def asset_config
        jekyll.config["assets"] ||= {}
      end

      # XXX: Doc

      def dev?
        %W(development test).include? \
          Jekyll.env
      end

      # XXX: Doc

      def cdn?
        !dev? && \
        !!asset_config["cdn"]
      end

      # There are two ways to enable digesting.  You can 1. be in production
      # or two, you can do the following in your `_config.yml`:
      # ```YAML
      # assets:
      #   digest: true

      def digest?
        !!asset_config["digest"]
      end

      # Checks to see if you would like to compress a specific type of file
      # You can configure this with:
      # ```YAML
      # assets:
      #   compress:
      #     css: true | false
      #      js: true | false
      # ```
      #
      # @see `setup_css_compressor`
      # @see ` setup_js_compressor`

      def compress?(what)
        !!asset_config["compress"][what]
      end

      # XXX: Doc

      def prefix
        asset_config["prefix"]
      end

      # XXX: Doc

      def prefix_path(path = nil)
        prefix = cdn? && asset_config["skip_prefix_with_cdn"] ? "" : self.prefix
        if cdn? && (cdn = asset_config["cdn"])
          return File.join(cdn, prefix) if !path
          File.join(cdn, prefix, path)
        else
          return  prefix if !path
          File.join(
            prefix, path
          )
        end
      end

      # See: `Cached`

      def cached
        Cached.new(self)
      end

      # See: `write_cached_assets`
      # See: `write_assets`

      def write_all
        if cached_write?
          then write_cached_assets else write_assets
        end
      end

      # Merge the defaults with your configuration so that there is always
      # some state and so that there need not be any configuration provided
      # by the user, this allows you to just accept our defaults while
      # changing only the things that you want changed.

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


        merge_into
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
          v.write_to as_path v
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
          next if nuevo == viejo

          self.class.digest_cache[a.logical_path] = a.digest
          a.write_to as_path a
        end
      end

      private
      def as_path(v)
        path = digest?? v.digest_path : v.logical_path
        jekyll.in_dest_dir(File.join(prefix, path))
      end

      # You can enable compression with:
      # ```YAML
      # assets:
      #   compress:
      #     css: true
      # ```

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
      # ```

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
        self.version = Digest::MD5.hexdigest( \
          jekyll.config.fetch("assets", {}).to_s)
      end

      # @see `Context#patch`

      private
      def patch_context
        Context.new(context_class)
      end

      # Append assets that you always wish to be compiled that aren't
      # ever really called but can be used in other ways:
      #
      # ```YAML
      # assets:
      #   assets:
      #     - "*.jpg"
      # ```
      #
      # This does not need to be a *, it can be a logical path or probably
      # even a full path... if `find_asset` will accept then we will accept it
      # too, with one difference, we will make sure it's in your source.

      private
      def append_sources
        asset_config["sources"].each do |v|
          append_path jekyll.in_source_dir(v)
        end
      end

      # Pass the logger onto `Jekyll`.
      # @see Logger
      # @see Jekyll

      private
      def setup_logger
        self.logger = Logger.new
      end

      # Sets up a cache directory for you, you can configure this
      # directory inside of your `_config.yml` with the assets key cache.
      # You can even disable it by making it `nil` or `false`.

      private
      def setup_cache
        cache_dir = asset_config.fetch("cache", ".asset-cache")

        if cache
          self.cache = Sprockets::Cache::FileStore.new \
            jekyll.in_source_dir(cache_dir)
        end
      end
    end
  end
end
