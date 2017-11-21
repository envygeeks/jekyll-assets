# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"
require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class Audio < HTML
        content_types "audio/aiff"
        content_types "audio/basic"
        content_types "audio/mpeg"
        content_types "audio/midi"
        content_types "audio/wave"
        content_types "audio/mp4"
        content_types "audio/ogg"
        content_types "audio/flac"
        content_types "audio/aac"

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
