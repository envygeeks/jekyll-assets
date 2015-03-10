# 3rd-party
require "liquid"

# internal
require "jekyll/assets/renderer"

module Jekyll
  module Assets
    class Tag < Liquid::Tag
      def render(context)
        Renderer.new(context, @markup).send :"render_#{@tag_name}"
      end
    end
  end
end

%w(asset asset_path image javascript stylesheet).each do |tag|
  Liquid::Template.register_tag tag, Jekyll::Assets::Tag
end
