module Jekyll
  module AssetsPlugin
    class AssetFile

      @@mtimes = Hash.new


      attr_reader :asset


      def initialize site, asset
        @site, @asset = site, asset
      end


      def content_type
        asset.content_type
      end


      def destination dest
        File.join dest, @site.assets_config.dirname, filename
      end


      def filename
        case cachebust = @site.assets_config.cachebust
        when :none, :soft then asset.logical_path
        when :hard        then asset.digest_path
        else raise "Unknown cachebust strategy: #{cachebust.inspect}"
        end
      end


      def path
        asset.pathname.to_s
      end


      def mtime
        asset.mtime.to_i
      end


      def modified?
        @@mtimes[path] != mtime
      end


      def write dest
        dest_path = destination dest

        return false if File.exist?(dest_path) and !modified?
        @@mtimes[path] = mtime

        asset.write_to dest_path
        asset.write_to "#{dest_path}.gz" if gzip?

        true
      end


      def == other
        case other
        when AssetFile        then asset == other.asset
        when Sprockets::Asset then asset == other
        else false
        end
      end


      def gzip?
        @site.assets_config.gzip.include? content_type
      end


      def to_s
        "#<Jekyll::AssetsPlugin::AssetFile:#{asset.logical_path}>"
      end

    end
  end
end
