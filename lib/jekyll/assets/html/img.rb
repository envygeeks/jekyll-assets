# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class HTML
      class IMG < HTML
        types "image/webp", "image/jpeg", "image/jpeg", "image/tiff",
          "image/bmp", "image/gif", "image/png", "image/svg+xml"

        def run
          Nokogiri::HTML::Builder.with(@doc) do |d|
            atr = @args.to_html({
              hash: true
            })

            d.img(atr)
          end
        end

        def self.for?(type:, args:)
          super && !args.key?(:srcset)
        end
      end
    end
  end
end
