# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class Audio < HTML
        content_types %r!^audio/[a-zA-Z0-9\-_]+$!

        # --
        def run
          Nokogiri::HTML::Builder.with(doc) do |d|
            d.audio("No support for audio.", args.to_h({
              html: true, skip: HTML.skips
            }))
          end
        end
      end
    end
  end
end
