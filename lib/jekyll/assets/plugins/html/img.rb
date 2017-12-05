# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"
require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class IMG < HTML
        content_types %r!^image/(?\!x-icon$)[a-zA-Z0-9\-_]+$!

        # --
        def run
          Nokogiri::HTML::Builder.with(doc) do |d|
            if srcset?
              complex(d)
            else
              d.img(args.to_h({
                html: true, skip: HTML.skips
              }))
            end
          end
        end

        # --
        def complex(doc)
          img = doc.img @args.to_h(html: true, skip: HTML.skips)
          Array(args[:srcset][:width]).each do |w|
            w, d = w.to_s.split(%r!\s+!, 2)
            Integer(w)

            img["srcset"] ||= ""
            img["srcset"] += ", #{path(width: w)} #{d || "#{w}w"}"
            img["srcset"] = img["srcset"].gsub(
              %r!^,\s*!, "")
          end
        end

        # --
        def path(width:)
          args_ = "#{args[:argv1]} magick:resize=#{width} @path"
          Tag.new("asset", args_, Liquid::ParseContext.new)
            .render(ctx)
        end

        # --
        def srcset?
          args.key?(:srcset) && args[:srcset]
            .key?(:width)
        end

        # --
        # @example {% asset src srcset="" %}
        # @example {% asset src %}
        # --
        def self.for?(type:, args:)
          return false unless super
          return false if args.key?(:pic)
          return false if args.key?(:inline) &&
              type == "image/svg+xml"

          true
        end
      end
    end
  end
end
