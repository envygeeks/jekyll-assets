# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Author: Jordon Bedwell
# Encoding: utf-8

require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class JS < HTML
        content_types "application/javascript"

        # --
        def run
          if asset.is_a?(Url) && args[:inline]
            raise Tag::MixedArg, "@external", "@inline"

          else
            Nokogiri::HTML::Builder.with(@doc) do |d|
              attr = args.to_h(html: true, skip: HTML.skips)
              d.script(@asset.to_s, attr) if args[:inline]
              d.script(attr) unless args[:inline]
            end
          end
        end
      end
    end
  end
end
