# 3rd-party
require 'liquid'


# internal
require 'jekyll/assets_plugin/renderer'


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
      def render context
        Renderer.new(context, @markup).send :"render_#{@tag_name}"
      end
    end
  end
end


%w{ javascript stylesheet asset asset_path }.each do |tag|
  Liquid::Template.register_tag tag, Jekyll::AssetsPlugin::Tag
end
