# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Liquid
      module Filters
        ACCEPTABLE_FILTERS = %W(
          css
          image
          asset_path
          stylesheet
          javascript
          style
          img
          js
        )

        ACCEPTABLE_FILTERS.each do |val|
          define_method val do |path, args = ""|
            Tag.send(:new, val, "#{path} #{args}", "").render(@context)
          end
        end
      end
    end
  end
end

# Register it with Liquid, good luck from here.
Liquid::Template.register_filter(Jekyll::Assets::Liquid::Filters)
