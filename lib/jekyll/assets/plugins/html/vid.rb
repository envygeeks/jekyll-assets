# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Author: Jordon Bedwell
# Encoding: utf-8

require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class Video < HTML
        content_types %r!^video/.*$!

        # --
        def run
          Nokogiri::HTML::Builder.with(doc) do |d|
            d.video("No support for video.", args.to_h(
              html: true, skip: HTML.skips
            ))
          end
        end
      end
    end
  end
end
