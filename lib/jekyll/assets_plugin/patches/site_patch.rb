# 3rd-party
require "jekyll"


# internal
require "jekyll/assets_plugin/configuration"
require "jekyll/assets_plugin/environment"
require "jekyll/assets_plugin/asset_file"


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


        def asset_path pathname, *args
          pathname, _, anchor = pathname.rpartition "#" if pathname["#"]
          pathname, _, query  = pathname.rpartition "?" if pathname["?"]

          asset     = assets[pathname, *args]
          baseurl   = "#{assets_config.baseurl}/"

          case cachebust = assets_config.cachebust
          when :none then baseurl << asset.logical_path
          when :soft then baseurl << asset.logical_path << "?cb=#{asset.digest}"
          when :hard then baseurl << asset.digest_path
          else raise "Unknown cachebust strategy: #{cachebust.inspect}"
          end

          baseurl << (:soft == cachebust ? "&" : "?") << query if query
          baseurl << "#" << anchor if anchor

          baseurl
        end


        def bundle_asset! asset
          if not asset_files.include? asset
            file = AssetFile.new self, asset

            asset.jekyll_assets.each{ |path| bundle_asset! assets[path] }

            asset_files   << file
            static_files  << file
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
