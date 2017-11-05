# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"
require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class IMG < HTML
        content_types "image/bmp"
        content_types "image/webp"
        content_types "image/svg+xml"
        content_types "image/jpeg"
        content_types "image/tiff"
        content_types "image/gif"
        content_types "image/png"

        def run
          Nokogiri::HTML::Builder.with(@doc) do |d|
            d.img(@args.to_h({
              html: true,
            }))
          end
        end

        def self.for?(type:, args:)
          super && !args.key?(:srcset)
        end
      end
    end
  end
end
