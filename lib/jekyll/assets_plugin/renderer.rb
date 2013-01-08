module Jekyll
  module AssetsPlugin
    class Renderer
      STYLESHEET = '<link rel="stylesheet" type="text/css" href="%s">'
      JAVASCRIPT = '<script type="text/javascript" src="%s"></script>'

      def initialize context, logical_path
        @site = context.registers[:site]
        @path = logical_path.strip
      end

      def render_asset
        asset.to_s
      end

      def render_asset_path
        unless @site.static_files.include? asset
          @site.static_files << AssetFile.new(@site, asset)
        end

        return "#{@site.assets_config.baseurl.chomp '/'}/#{asset.digest_path}"
      end

      def render_javascript
        @path << '.js' if File.extname(@path).empty?

        JAVASCRIPT % render_asset_path
      end

      def render_stylesheet
        @path << '.css' if File.extname(@path).empty?

        STYLESHEET % render_asset_path
      end

      protected

      def asset
        unless @asset ||= @site.assets[@path]
          raise AssetFile::NotFound, "couldn't find file '#{@path}'"
        end

        @asset
      end
    end
  end
end

