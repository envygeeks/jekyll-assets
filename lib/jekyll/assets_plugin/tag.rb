# 3rd-party
require 'liquid'


# stdlib
require 'set'


# internal
require 'jekyll/assets_plugin/logging'


module Jekyll
  module AssetsPlugin
    # Class that implements some useful liquid tags:
    #
    #
    # ##### stylesheet
    #
    # Renders `<link>` tag for a logical path:
    #
    #     {% stylesheet foo.css %}
    #     # => '<link type="text/css" rel="stylesheet"
    #           href="/assets/foo-b39e528efc3afe2def4bbc39de17f2b82cd8bd0d.css">
    #
    # You may omit extension so the following will give same result as above:
    #
    #     {% stylesheet foo %}
    #
    #
    # ##### javascript
    #
    # Renders `<script>` tag for a logical path:
    #
    #     {% javascript foo.js %}
    #     # => '<script type="text/javascript"
    #           src="/assets/foo-b39e528efc3afe2def4bbc39de17f2b82cd8bd0d.js">
    #           </script>
    #
    # You may omit extension so the following will give same result as above:
    #
    #     {% javascript foo %}
    #
    #
    # ##### asset_path
    #
    # Renders asset path for an asset (useful for images):
    #
    #     {% asset_path foo.jpg %}
    #     # => '/assets/foo-b39e528efc3afe2def4bbc39de17f2b82cd8bd0d.jpg"
    #
    #
    class Tag < Liquid::Tag
      include Logging

      STYLESHEET = '<link rel="stylesheet" type="text/css" href="%s">'
      JAVASCRIPT = '<script type="text/javascript" src="%s"></script>'
      EXTENSIONS = { 'stylesheet' => '.css', 'javascript' => '.js' }

      @@errors   = Set.new

      def initialize tag_name, logical_path, tokens
        super

        @logical_path = logical_path.strip

        # append auto-guessed extension if needed
        @logical_path << default_extension if File.extname(@logical_path).empty?
      end

      def render context
        send :"render_#{@tag_name}", context
      end

      protected

      def default_extension
        EXTENSIONS[@tag_name].to_s
      end

      def asset_not_found
        if @@errors.add? @logical_path
          log :error, "File not found: #{@logical_path}"
        end
      end

      def asset_not_bundled
        if @@errors.add? @logical_path
          log :warn, "File was not bundled: #{@logical_path}"
        end
      end

      def with_asset context, &block
        site    = context.registers[:site]
        asset   = site.assets[@logical_path]

        return asset_not_found unless asset

        yield asset, site
      end

      def render_asset context
        with_asset context do |asset|
          return asset.to_s
        end
      end

      def render_asset_path context
        with_asset context do |asset, site|
          return asset_not_bundled unless site.has_bundled_asset? asset
          return "#{site.config['url']}/#{site.assets_config.dirname}/#{asset.digest_path}"
        end
      end

      def render_javascript context
        if url = render_asset_path(context)
          return JAVASCRIPT % [url]
        end
      end

      def render_stylesheet context
        if url = render_asset_path(context)
          return STYLESHEET % [url]
        end
      end
    end
  end
end
