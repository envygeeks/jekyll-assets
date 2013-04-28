module Jekyll
  module AssetsPlugin
    class AssetFile

      @@mtimes = Hash.new


      attr_reader :logical_path


      def initialize site, asset
        @site, @logical_path = site, asset.logical_path
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


      def asset
        @site.assets[logical_path]
      end


      def content_type
        asset.content_type
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
        return false unless other.respond_to? :logical_path
        other.logical_path == logical_path
      end


      def gzip?
        @site.assets_config.gzip.include? content_type
      end


      def to_s
        "#<Jekyll::AssetsPlugin::AssetFile:#{logical_path}>"
      end

    end
  end
end
