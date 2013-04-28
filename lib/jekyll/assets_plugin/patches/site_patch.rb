# 3rd-party
require "jekyll"


# internal
require "jekyll/assets_plugin/configuration"
require "jekyll/assets_plugin/environment"


module Jekyll
  module AssetsPlugin
    module Patches
      module SitePatch

        def self.included base
          base.class_eval do
            alias_method :write_without_assets, :write
            alias_method :write, :write_with_assets
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
          asset     = assets[*args]
          baseurl   = "#{assets_config.baseurl}/"
          cachebust = assets_config.cachebust

          case cachebust
          when :none then baseurl << asset.logical_path
          when :soft then baseurl << asset.logical_path << "?cb=#{asset.digest}"
          when :hard then baseurl << asset.digest_path
          else raise "Unknown cachebust strategy: #{cachebust.inspect}"
          end
        end


        def bundle_asset! asset
          if not asset_files.include? asset
            file = AssetFile.new self, asset

            asset_files   << file
            static_files  << file
          end
        end


        def write_with_assets
          static_files.push(*asset_files).uniq!
          write_without_assets
        end

      end
    end
  end
end


Jekyll::Site.send :include, Jekyll::AssetsPlugin::Patches::SitePatch
