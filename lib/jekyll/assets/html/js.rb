# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class HTML
      class JS < HTML
        types "application/javascript",
          "text/javascript"

        def run
          doc = Nokogiri::HTML::DocumentFragment.parse("")
          Nokogiri::HTML::Builder.with(doc) do |d|
            atr = @args.to_html(hash: true)
            d.script(@asset.to_s, atr) if @args[:inline]
            d.script(atr) unless @args[:inline]
          end

          doc
        end
      end
    end
  end
end
