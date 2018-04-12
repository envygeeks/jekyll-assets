# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "jekyll/assets"
require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class IMG < HTML
        content_types %r!^image/(?\!x-icon$)[a-zA-Z0-9\-_\+]+$!

        # --
        def run
          Nokogiri::HTML::Builder.with(doc) do |d|
            srcset? ? complex(d) : d.img(args.to_h({
              html: true, skip: HTML.skips
            }))
          end
        end

        # --
        def complex(doc)
          img = doc.img @args.to_h(html: true, skip: HTML.skips)
          Array(args[:srcset][:width]).each do |w|
            dimensions, density, type = w.to_s.split(%r!\s+!, 3)

            img["srcset"] ||= ""
            img["srcset"] += ", #{path(dimensions: dimensions, type: type)} "
            img["srcset"] += density || "#{dimensions}w"
            img["srcset"] = img["srcset"]
              .gsub(%r!^,\s*!, "")
          end
        end

        # --
        def path(dimensions:, type: nil)
          args_ =  "#{args[:argv1]} @path"
          args_ += " magick:resize=#{dimensions}"
          args_ += " magick:format=#{type}" if type
          args_ += " @optim" if args.key?(:optim)

          pctx = Liquid::ParseContext.new
          tag = Tag.new("asset", args_, pctx)
          tag.render(ctx)
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
