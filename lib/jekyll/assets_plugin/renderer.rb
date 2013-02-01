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
        @site.find_asset(@path).to_s
      end


      def render_asset_path
        asset = @site.find_asset @path, :require => true
        "#{@site.assets_config.baseurl}/#{asset.digest_path}"
      end


      def render_javascript
        @path << '.js' if File.extname(@path).empty?

        JAVASCRIPT % render_asset_path
      end


      def render_stylesheet
        @path << '.css' if File.extname(@path).empty?

        STYLESHEET % render_asset_path
      end

    end
  end
end

