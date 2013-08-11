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

        if @site.assets_config.debug
          return @site.assets[@path].to_a.map{ |a|
            JAVASCRIPT % @site.asset_path(a.logical_path, :bundle => false)
          }.join("\n")
        end

        JAVASCRIPT % render_asset_path
      end


      def render_stylesheet
        @path << ".css" if File.extname(@path).empty?

        if @site.assets_config.debug
          return @site.assets[@path].to_a.map{ |a|
            STYLESHEET % @site.asset_path(a.logical_path, :bundle => false)
          }.join("\n")
        end

        STYLESHEET % render_asset_path
      end

    end
  end
end

