# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"
require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class JS < HTML
        content_types "application/javascript",
          "text/javascript"

        def run
          Nokogiri::HTML::Builder.with(@doc) do |d|
            atr = @args.to_h(html: true)
            d.script(@asset.to_s, atr) if @args[:inline]
            d.script(atr) unless @args[:inline]
          end
        end
      end
    end
  end
end
