module Jekyll
  module AssetsPlugin
    class Renderer

      STYLESHEET = '<link rel="stylesheet" type="text/css" href="%s" data-turbolinks-track>'
      JAVASCRIPT = '<script type="text/javascript" src="%s" data-turbolinks-track></script>'


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

        ret = JAVASCRIPT % render_asset_path
        if !@site.assets_config.turbolinks?
          ret = ret.gsub(/data-turbolinks-track/, '')
        end
        ret
      end


      def render_stylesheet
        @path << ".css" if File.extname(@path).empty?

        ret = STYLESHEET % render_asset_path
        if !@site.assets_config.turbolinks?
          ret = ret.gsub(/data-turbolinks-track/, '')
        end
        ret
      end

    end
  end
end

