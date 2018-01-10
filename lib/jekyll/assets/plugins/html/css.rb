# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "jekyll/assets"
require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class CSS < HTML
        content_types "text/css"

        # --
        def run
          Nokogiri::HTML::Builder.with(@doc) do |d|
            attr = @args.to_h(html: true, skip: HTML.skips)
            d.style(asset.to_s, attr) if @args[:inline]
            d.link(attr) unless @args[:inline]
          end
        end
      end
    end
  end
end
