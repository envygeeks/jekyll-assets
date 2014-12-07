# 3rd-party
require "fastimage"

module Jekyll
  module AssetsPlugin
    class Renderer
      STYLESHEET = '<link rel="stylesheet" href="%{path}"%{attrs}>'
      JAVASCRIPT = '<script src="%{path}"%{attrs}></script>'
      IMAGE      = '<img src="%{path}"%{attrs}>'
      IMAGESIZE  = 'width="%d" height="%d"'
      AUTOSIZE   = "[autosize]"

      URI_RE     = %r{^(?:[^:]+:)?//(?:[^./]+\.)+[^./]+/}
      PARAMS_RE  = / (?: "(?<path>[^"]+)" | '(?<path>[^']+)' | (?<path>[^ ]+) )
                     (?<attrs>.*)
                   /x

      attr_reader :site, :path, :attrs

      def initialize(context, params)
        @site = context.registers[:site]

        match = params.strip.match PARAMS_RE

        @path  = match["path"]
        @attrs = match["attrs"]
      end

      def render_asset
        fail "Can't render remote asset: #{path}" if remote?
        site.assets[path].to_s
      end

      def render_asset_path
        return path if remote?
        site.asset_path path
      end

      def render_javascript
        render_tag JAVASCRIPT, ".js"
      end

      def render_stylesheet
        render_tag STYLESHEET, ".css"
      end

      def render_image
        unless attrs =~ /width|height/
          if attrs.include? AUTOSIZE
            attrs.sub! AUTOSIZE, render_image_size
          elsif site.assets_config.autosize_images
            attrs << " " unless attrs =~ /\s$/
            attrs << render_image_size
          end
        end

        render_tag IMAGE
      end

      private

      def render_tag(template, extension = "")
        return format(template, :path => path, :attrs => attrs) if remote?

        path << extension if extension.to_s != File.extname(path)

        asset = site.assets[path]
        tags  = (site.assets_config.debug ? asset.to_a : [asset]).map do |a|
          format template, :path => AssetPath.new(a).to_s, :attrs => attrs
        end

        tags.join "\n"
      end

      def render_image_size
        if remote?
          size = FastImage.size(path)
        else
          size = FastImage.size(site.assets[path].pathname)
        end
        format IMAGESIZE, *size
      end

      def remote?
        path =~ URI_RE
      end
    end
  end
end
