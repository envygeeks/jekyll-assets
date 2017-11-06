# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"

module Jekyll
  module Assets
    class HTML
      class SVG < HTML
        content_types "image/svg+xml"

        # --
        def run
          if @asset.is_a?(Url) && @args[:inline]
            raise Tag::MixedArg, "@external", "@inline"

          else
            arg = @args.to_h(html: true)
            arg.each do |k, v|
              @doc.set_attribute(k, v)
            end
          end
        end

        # --
        def self.wants_xml?
          true
        end

        # --
        def self.for?(type:, args:)
          super && args[:inline] && !args.key?(:srcset)
        end
      end
    end
  end
end
