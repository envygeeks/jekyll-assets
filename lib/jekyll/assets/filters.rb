module Jekyll
  module Assets
    module Filters
      %W(js css img image javascript stylesheet style asset_path).each do |v|
        define_method v do |path, args = ""|
          Tag.send(:new, v, "#{path} #{args}", "").render(
            @context
          )
        end
      end
    end
  end
end

Liquid::Template.register_filter(
  Jekyll::Assets::Filters
)
