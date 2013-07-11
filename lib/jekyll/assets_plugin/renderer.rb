module Jekyll
  module AssetsPlugin
    class Renderer

      STYLESHEET = '<link rel="stylesheet" href="%s">'
      JAVASCRIPT = '<script src="%s"></script>'


      def initialize context, logical_path
        @site = context.registers[:site]
        @path = logical_path.strip
      end


      def render_asset
        @site.assets[@path].to_s
      end


      def render_asset_path
        @site.asset_path @path
      end


      def render_javascript
        @path << ".js" if File.extname(@path).empty?

        JAVASCRIPT % render_asset_path
      end


      def render_stylesheet
        @path << ".css" if File.extname(@path).empty?

        STYLESHEET % render_asset_path
      end

    end
  end
end

