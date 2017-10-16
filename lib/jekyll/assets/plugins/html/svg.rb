# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"

module Jekyll
  module Assets
    class HTML
      class SVG < HTML
        types "image/svg+xml"

        def run
          arg = @args.to_html(hash: true)
          arg.each do |k, v|
            @doc.set_attribute(k, v)
          end
        end

        def self.wants_xml?
          true
        end

        def self.for?(type:, args:)
          super && args[:inline] && !args.key?(:srcset)
        end
      end
    end
  end
end
