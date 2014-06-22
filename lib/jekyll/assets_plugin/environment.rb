# stdlib
require "pathname"

# 3rd-party
require "sass"
require "sprockets"

module Jekyll
  module AssetsPlugin
    class Environment < Sprockets::Environment
      class AssetNotFound < StandardError
        def initialize(path)
          super "Couldn't find file '#{path}'"
        end
      end

      attr_reader :site

      def initialize(site)
        super site.source

        @site = site

        # append asset paths
        site.assets_config.sources.each { |p| append_path p }

        self.js_compressor   = site.assets_config.js_compressor
        self.css_compressor  = site.assets_config.css_compressor

        if site.assets_config.cache_assets?
          self.cache = Sprockets::Cache::FileStore.new cache_path
        end

        # load css autoprefix post-processor
        install_autoprefixer!

        # reset cache if config changed
        self.version = site.assets_config.marshal_dump

        # bind jekyll and Sprockets context together
        context_class.instance_variable_set :@site, site
        context_class.send :include, Patches::ContextPatch
      end

      def cache_path
        Pathname.new(@site.source).join @site.assets_config.cache_path
      end

      def find_asset(path, *args)
        super || fail(AssetNotFound, path)
      end

      private

      def install_autoprefixer!
        require "autoprefixer-rails"
        AutoprefixerRails.install(self)
      rescue LoadError
        nil
      end
    end
  end
end
