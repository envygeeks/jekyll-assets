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

          # bind jekyll and Sprockets context together
          @assets.context_class.instance_variable_set :@jekyll_site, self

          @assets.context_class.class_eval do
            def jekyll_site
              self.class.instance_variable_get :@jekyll_site
            end

            def asset_baseurl
              jekyll_site.assets_config.baseurl.chomp "/"
            end

            def asset_path(path, options = {})
              unless (asset = environment.find_asset path, options)
                raise AssetFile::NotFound, "couldn't find file '#{path}'"
              end

              unless jekyll_site.static_files.include? asset
                jekyll_site.static_files << AssetFile.new(jekyll_site, asset)
              end

              "#{asset_baseurl}/#{asset.digest_path}".squeeze "/"
            end
          end
        end

        @assets
      end
    end
  end
end
