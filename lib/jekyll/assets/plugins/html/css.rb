# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"
require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class CSS < HTML
        content_types "text/css"

        def run
          if @asset.is_a?(Url) && @args[:inline]
            raise Errors::Generic, "cannot inline external" \
              "invalid argument @inline"
          else
            Nokogiri::HTML::Builder.with(@doc) do |d|
              atr = @args.to_h(html: true)
              d.style(asset.to_s, atr) if @args[:inline]
              d.link(atr) unless @args[:inline]
            end
          end
        end
      end
    end
  end
end
