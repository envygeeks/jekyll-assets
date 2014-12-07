# 3rd-party
require "fastimage"

module Jekyll
  module AssetsPlugin
    class Renderer
      STYLESHEET = '<link rel="stylesheet" href="%{path}"%{attrs}>'
      JAVASCRIPT = '<script src="%{path}"%{attrs}></script>'
      IMAGE      = '<img src="%{path}"%{attrs}>'
      IMAGESIZE  = 'width="%d" height="%d"'

      URI_RE     = %r{^(?:[^:]+:)?//(?:[^./]+\.)+[^./]+/}
      PARAMS_RE  = / ^
                     \s*
                     (?: "(?<path>[^"]+)" | '(?<path>[^']+)' | (?<path>[^ ]+) )
                     (?<attrs>.*?)
                     (?: \[(?<options>.*)\] )?
                     \s*
                     $
                   /x

      attr_reader :site, :path, :attrs, :options

      def initialize(context, params)
        @site = context.registers[:site]

        match = params.strip.match PARAMS_RE

        @path     = match["path"]
        @attrs    = match["attrs"]
        @options  = match["options"].to_s.split(",")
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
        autosize!
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

      def autosize!
        return unless autosize?

        if remote?
          width, height = FastImage.size(path)
        else
          width, height = FastImage.size(site.assets[path].pathname)
        end

        @attrs = %(#{@attrs} width="#{width}" height="#{height}").strip
      end

      def autosize?
        if site.assets_config.autosize
          !options.include? "no-autosize"
        else
          options.include? "autosize"
        end
      end

      def remote?
        path =~ URI_RE
      end
    end
  end
end
