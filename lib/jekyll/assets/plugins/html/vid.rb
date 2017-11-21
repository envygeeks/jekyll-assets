# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"
require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class Video < HTML
        content_types "video/avi"
        content_types "video/webm"
        content_types "video/mp4"

        def run
          Nokogiri::HTML::Builder.with(doc) do |d|
            d.video("No support for video.", args.to_h({
              html: true, skip: HTML.skips
            }))
          end
        end
      end
    end
  end
end
