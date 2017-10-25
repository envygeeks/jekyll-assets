# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require "jekyll/assets"
require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class CSS < HTML
        types "text/css"

        def run
          Nokogiri::HTML::Builder.with(@doc) do |d|
            atr = @args.to_html(hash: true)
            d.style(asset.to_s, atr) if @args[:inline]
            d.link(atr) unless @args[:inline]
          end
        end
      end
    end
  end
end
