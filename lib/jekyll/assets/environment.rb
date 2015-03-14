# stdlib
require "pathname"

# 3rd-party
require "sass"
require "sprockets"
require "sprockets-sass"
require "sprockets-helpers"

module Jekyll
  module Assets
    class Environment < Sprockets::Environment
      class AssetNotFound < StandardError
        def initialize(path)
          super "Couldn't find file '#{path}'"
        end
      end

      attr_reader :site

      # rubocop:disable Metrics/AbcSize
      def initialize(site)
        super site.source

        @site = site

        # append asset paths
        site.assets_config.sources.each { |p| append_path p }
        append_path resize_cache_path

        self.js_compressor   = site.assets_config.js_compressor
        self.css_compressor  = site.assets_config.css_compressor

        Jekyll::Assets::HOOKS.each { |block| block.call(self) }

        if site.assets_config.cache_assets?
          self.cache = Sprockets::Cache::FileStore.new cache_path
        end

        # reset cache if config changed
        self.version = site.assets_config.marshal_dump

        # bind jekyll and Sprockets context together
        context_class.instance_variable_set :@site, site
        context_class.send :include, Patches::ContextPatch
      end
      # rubocop:enable Metrics/AbcSize

      def cache_path
        Pathname.new(@site.source).join @site.assets_config.cache_path
      end

      def resize_cache_path
        cache_path.join "resize"
      end

      def find_asset(path, *args)
        super || fail(AssetNotFound, path)
      end
    end
  end
end
