# 3rd-party
require 'sprockets'


# internal
require 'jekyll/assets_plugin/asset_file'
require 'jekyll/assets_plugin/configuration'


module Jekyll
  module AssetsPlugin
    # Patch that provides #assets and #assets_config to Site
    #
    module SitePatch
      def assets_config
        @assets_config ||= Configuration.new(self.config['assets'] || {})
      end

      def assets
        unless @assets
          @assets = Sprockets::Environment.new(self.source)

          assets_config.sources.each(&@assets.method(:append_path))

          @assets.js_compressor   = assets_config.js_compressor
          @assets.css_compressor  = assets_config.css_compressor

          # TODO: automagically bundle files

          @assets.context_class.class_eval <<-RUBY, __FILE__, __LINE__
            def asset_path(path, options = {})
              asset = environment.find_asset path, options
              raise FileNotFound, "couldn't find file '\#{path}'" unless asset
              "/#{assets_config.baseurl.chomp '/'}/\#{asset.digest_path}".squeeze "/"
            end
          RUBY
        end

        @assets
      end
    end
  end
end
