module Jekyll
  module AssetsPlugin
    class AssetFile

      @@mtimes = Hash.new


      attr_reader :asset


      def initialize site, asset
        @site, @asset = site, asset
      end


      def destination dest
        case @site.assets_config.cachebust
        when :none then File.join(dest, @site.assets_config.dirname, @asset.logical_path)
        when :soft then File.join(dest, @site.assets_config.dirname, @asset.logical_path)
        when :hard then File.join(dest, @site.assets_config.dirname, @asset.digest_path)
        else raise "Unknown cachebast strategy: #{@site.assets_config.cachebust}"
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
