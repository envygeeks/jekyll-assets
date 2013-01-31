# 3rd-party
require 'sprockets'


# internal
require 'jekyll/assets_plugin/asset_file'
require 'jekyll/assets_plugin/configuration'
require 'jekyll/assets_plugin/liquid_processor'


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

          # bind jekyll and Sprockets context together
          @assets.context_class.instance_variable_set :@site, self

          @assets.context_class.class_eval do
            def site
              self.class.instance_variable_get :@site
            end

            def asset_baseurl
              site.assets_config.baseurl.chomp "/"
            end

            def asset_path(path, options = {})
              unless (asset = environment.find_asset path, options)
                raise AssetFile::NotFound, "couldn't find file '#{path}'"
              end

              unless site.static_files.include? asset
                site.static_files << AssetFile.new(site, asset)
              end

              "#{asset_baseurl}/#{asset.digest_path}".squeeze "/"
            end
          end

          %w{ text/css application/javascript}.each do |mime|
            @assets.register_preprocessor mime, LiquidProcessor
          end
        end

        @assets
      end
    end
  end
end


Jekyll::Site.send :include, Jekyll::AssetsPlugin::SitePatch
