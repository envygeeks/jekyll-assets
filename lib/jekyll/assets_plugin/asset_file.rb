module Jekyll
  module AssetsPlugin
    class AssetFile

      @@mtimes = Hash.new


      attr_reader :asset


      def initialize site, asset
        @site, @asset = site, asset
      end


      def destination dest
        File.join dest, @site.assets_config.dirname, filename
      end


      def filename
        cachebust = @site.assets_config.cachebust

        case cachebust
        when :none, :soft then asset.logical_path
        when :hard        then asset.digest_path
        else raise "Unknown cachebust strategy: #{cachebust.inspect}"
        end
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
        when AssetFile        then same_asset? other.asset
        when Sprockets::Asset then same_asset? other
        else false
        end
      end


      def to_s
        "#<Jekyll::AssetsPlugin::AssetFile:#{asset.logical_path}>"
      end


      protected


      def same_asset? other
        other.pathname.cleanpath == asset.pathname.cleanpath
      end

    end
  end
end
