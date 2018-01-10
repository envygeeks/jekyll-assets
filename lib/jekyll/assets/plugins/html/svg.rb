# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "jekyll/assets"

module Jekyll
  module Assets
    class HTML
      class SVG < HTML
        content_types "image/svg+xml"

        # --
        def run
          arg = @args.to_h(html: true)
          arg.each do |k, v|
            @doc.set_attribute(k, v)
          end
        end

        # --
        def self.wants_xml?
          true
        end

        # --
        def self.for?(type:, args:)
          return false unless super
          return false unless args.key?(:inline) &&
              !args.key?(:srcset)

          true
        end
      end
    end
  end
end
