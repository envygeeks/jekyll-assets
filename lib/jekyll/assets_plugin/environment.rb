# stdlib
require "pathname"

# 3rd-party
require "sass"
require "sprockets"
require "sprockets-sass"
require "sprockets-helpers"

module Jekyll
  module AssetsPlugin
    class Environment < Sprockets::Environment
      AUTOPREFIXER_CONFIG_FILES = %w(autoprefixer.yml _autoprefixer.yml)
      RESIZE_CACHE_DIRECTORY = "/tmp/jekyll-asset-resize-cache"

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
        append_path RESIZE_CACHE_DIRECTORY

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
      # rubocop:enable Metrics/AbcSize

      def cache_path
        Pathname.new(@site.source).join @site.assets_config.cache_path
      end

      def find_asset(path, *args)
        super || fail(AssetNotFound, path)
      end

      private

      def browsers
        config = autoprefixer_config
        opts   = { :safe => config.delete(:safe) }

        [config, opts]
      end

      def autoprefixer_config
        config_file = AUTOPREFIXER_CONFIG_FILES
                      .map { |f| Pathname.new(@site.source).join f }
                      .find(&:exist?)

        return {} unless config_file

        YAML.load_file(config_file).reduce({}) do |h, (k, v)|
          h.update(k.to_sym => v)
        end
      end

      def install_autoprefixer!
        require "autoprefixer-rails"
        AutoprefixerRails.install(self, *browsers)
      rescue LoadError
        nil
      end
    end
  end
end
