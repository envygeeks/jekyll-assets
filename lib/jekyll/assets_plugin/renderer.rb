module Jekyll
  module AssetsPlugin
    class Renderer
      STYLESHEET = '<link rel="stylesheet" href="%{path}"%{attrs}>'
      JAVASCRIPT = '<script src="%{path}"%{attrs}></script>'
      IMAGE      = '<img src="%{path}"%{attrs}>'

      URI_RE     = %r{^(?:[^:]+:)?//(?:[^./]+\.)+[^./]+/}

      def initialize(context, logical_path)
        @site   = context.registers[:site]
        @path   = logical_path.strip

        @path, _, @attrs = @path.partition(" ") if @path[" "]
        @attrs.prepend(" ") if @attrs
      end

      def render_asset
        fail "Can't render remote asset: #{@path}" if remote?
        @site.assets[@path].to_s
      end

      def render_asset_path
        return @path if remote?
        @site.asset_path @path
      end

      def render_javascript
        render_tag JAVASCRIPT, ".js"
      end

      def render_stylesheet
        render_tag STYLESHEET, ".css"
      end

      def render_image
        render_tag IMAGE
      end

      private

      def render_tag(template, extension = "")
        return format(template, :path => @path, :attrs => @attrs) if remote?

        @path << extension if extension.to_s != File.extname(@path)

        asset = @site.assets[@path]
        tags  = (@site.assets_config.debug ? asset.to_a : [asset]).map do |a|
          format template, :path => AssetPath.new(a).to_s, :attrs => @attrs
        end

        tags.join "\n"
      end

      def remote?
        @path =~ URI_RE
      end
    end
  end
end
