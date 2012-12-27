# stdlib
require 'set'


module Jekyll
  module AssetsPlugin
    # Represents single asset that can be used as StaticFile for Site
    #
    class AssetFile
      @@mtimes = Hash.new

      attr_reader :asset

      def initialize site, asset
        @site, @asset = site, asset
      end

      def destination dest
        File.join(dest, @site.assets_config.dirname, @asset.digest_path)
      end

      def path
        @asset.pathname.to_s
      end

      def mtime
        @asset.mtime.to_i
      end

      def modified?
        @@mtimes[path] != mtime
      end

      def write dest
        dest_path = destination dest

        return false if File.exist?(dest_path) and !modified?
        @@mtimes[path] = mtime

        @asset.write_to dest_path
        true
      end

      def == other
        case other
        when AssetFile        then other.asset.logical_path == asset.logical_path
        when Sprockets::Asset then other.logical_path == asset.logical_path
        else false
        end
      end

      def to_s
        "#<Jekyll::AssetsPlugin::AssetFile:#{asset.logical_path}>"
      end
    end
  end
end
