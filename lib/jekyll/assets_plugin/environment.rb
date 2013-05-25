# 3rd-party
require "sprockets"


module Jekyll
  module AssetsPlugin
    class Environment < Sprockets::Environment

      class AssetNotFound < StandardError
        def initialize path
          super "Couldn't find file '#{path}'"
        end
      end


      attr_reader :site


      def initialize site
        super site.source

        @site = site

        # append asset paths
        @site.assets_config.sources.each { |p| append_path p }

        self.js_compressor   = @site.assets_config.js_compressor
        self.css_compressor  = @site.assets_config.css_compressor

        @sprockets_cache_path = File.join(@site.config['source'], 'tmp', 'cache')
        self.cache           = Sprockets::Cache::FileStore.new(@sprockets_cache_path)

        # bind jekyll and Sprockets context together
        context_class.instance_variable_set :@site, @site

        context_class.send :include, Patches::ContextPatch
      end


      def find_asset path, *args
        super or raise AssetNotFound, path
      end

    end
  end
end
