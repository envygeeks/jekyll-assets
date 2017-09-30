# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Liquid
      module Filters
        FILTERS = [:css, :img, :asset_path, :stylesheet,
          :javascript, :style, :image, :js]

        # --
        # The base filters.
        # --
        FILTERS.each do |val|
          define_method val do |path, args = ""|
            Tag.send(:new, val, "#{path} #{args}", ParseContext.new)
              .render(@context)
          end
        end

        # --
        # jekyll_asset_multi allos you to include multiple assets.
        # @return [Strings]
        # --
        def jekyll_asset_multi(assets)
          Shellwords.shellsplit(assets).map { |s| s.split(":", 2) }.map do |t, a|
            tag = Tag.send(:new, t, a, ParseContext.new)
            tag.render(@context)
          end.join("\n")
        end
      end

    end
  end
end

Liquid::Template.register_filter(Jekyll::Assets::Liquid::Filters)
