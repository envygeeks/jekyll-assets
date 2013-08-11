# 3rd-party
require "jekyll"


# internal
require "jekyll/assets_plugin/configuration"
require "jekyll/assets_plugin/environment"
require "jekyll/assets_plugin/asset_path"


module Jekyll
  module AssetsPlugin
    module Patches
      module SitePatch

        def self.included base
          base.class_eval do
            alias_method :__orig_write, :write
            alias_method :write, :__wrap_write
          end
        end


        def assets_config
          @assets_config ||= Configuration.new(self.config["assets"] || {})
        end


        def assets
          @assets ||= Environment.new self
        end


        def asset_files
          @asset_files ||= []
        end


        def asset_path *args
          AssetPath.new(self, *args).to_s
        end


        def bundle_asset! asset
          if not asset_files.include? asset
            asset_files << asset
            asset.jekyll_assets.each{ |path| bundle_asset! assets[path] }
          end
        end


        def __wrap_write
          static_files.push(*asset_files).uniq!
          __orig_write
        end

      end
    end
  end
end


Jekyll::Site.send :include, Jekyll::AssetsPlugin::Patches::SitePatch
