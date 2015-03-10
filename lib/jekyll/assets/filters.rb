# internal
require "jekyll/assets/renderer"

module Jekyll
  module Assets
    module Filters
      %w(asset asset_path image javascript stylesheet).each do |name|
        module_eval <<-RUBY, __FILE__, __LINE__
        def #{name} path                    # def stylesheet logical_path
          r = Renderer.new @context, path   #   r = Renderer.new @context, path
          r.render_#{name}                  #   r.render_stylesheet
        end                                 # end
        RUBY
      end
    end
  end
end

Liquid::Template.register_filter Jekyll::Assets::Filters
