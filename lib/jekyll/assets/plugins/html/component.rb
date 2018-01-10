# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "jekyll/assets"
require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class Component < HTML
        content_types "text/html"

        # --
        def run
          Nokogiri::HTML::Builder.with(doc) do |d|
            d.link args.to_h({
              html: true, skip: HTML.skips
            })
          end
        end
      end
    end
  end
end
