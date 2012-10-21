# internal
require 'jekyll/assets_plugin/logging'
require 'jekyll/assets_plugin/asset_file'


module Jekyll
  module AssetsPlugin
    # Jekyll hook that bundles all files specified in `bundles` config
    #
    class Generator < ::Jekyll::Generator
      include Logging

      safe false
      priority :low

      def generate site
        filenames = site.assets_config.bundle_filenames
        site.assets.each_logical_path(filenames).each do |logical_path|
          if asset = site.assets.find_asset(logical_path)
            site.static_files << AssetFile.new(site, asset) if asset
          end
        end
      end
    end
  end
end
