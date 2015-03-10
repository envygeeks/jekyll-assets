# stdlib
require "digest/md5"

# 3rd-party
require "jekyll"

# internal
require "jekyll/assets/configuration"
require "jekyll/assets/environment"
require "jekyll/assets/asset_path"

module Jekyll
  module Assets
    module Patches
      module SitePatch
        def self.included(base)
          base.class_eval do
            alias_method :__orig_write, :write
            alias_method :write, :__wrap_write
          end
        end

        def assets_config
          @assets_config ||= Configuration.new(self, config["assets"] || {})
        end

        def assets
          @assets ||= Environment.new self
        end

        def asset_files
          @asset_files ||= Set.new
        end

        def asset_path(pathname, *args)
          pathname, _, anchor = pathname.rpartition "#" if pathname["#"]
          pathname, _, query  = pathname.rpartition "?" if pathname["?"]

          asset_path = AssetPath.new assets[pathname, *args]
          asset_path.anchor = anchor
          asset_path.query  = query

          asset_path.to_s
        end

        def bundle_asset!(asset)
          return if asset_files.include? asset

          asset_files << asset
          asset.jekyll_assets.each { |path| bundle_asset! assets[path] }
        end

        def __wrap_write
          static_files.push(*asset_files)
          __orig_write
        end
      end
    end
  end
end

Jekyll::Site.send :include, Jekyll::Assets::Patches::SitePatch
