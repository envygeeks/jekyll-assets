# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

module Jekyll
  module Assets
    module Liquid
      module Filters
        ACCEPTABLE_FILTERS = [:css, :img, :asset_path, :stylesheet,
          :javascript, :style, :image, :js]

        # --
        # The base filters.
        # --
        ACCEPTABLE_FILTERS.each do |val|
          define_method val do |path, args = ""|
            Tag.send(:new, val, "#{path} #{args}", ParseContext.new).render(
              @context
            )
          end
        end

        # --
        # Include multiple assets.
        # @return [Strings]
        # --
        def jekyll_asset_multi(assets)
          return Shellwords.shellsplit(assets).map { |s| s.split(":", 2) }.map do |tag, arguments|
            Tag.send(:new, tag, arguments, ParseContext.new).render(
              @context
            )
          end \

          .join(
            "\n"
          )
        end
      end

      #

      ::Liquid::Template.register_filter(
        Filters
      )
    end
  end
end
