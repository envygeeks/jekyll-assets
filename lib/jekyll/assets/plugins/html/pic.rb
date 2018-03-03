# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "jekyll/assets"
require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class Pic < HTML
        content_types %r!^image/(?\!x-icon$)[a-zA-Z0-9\-_]+$!

        # --
        # @todo this should be reworked so we don't need to use
        #   tag to loop back in on ourselves.
        # --
        def run
          args[:picture] ||= {}
          Nokogiri::HTML::Builder.with(doc) do |d|
            if proper_pic?
              complex(d)
            else
              d.picture args[:picture] do
                d.img args.to_h({
                  html: true, skip: HTML.skips + %i(
                    picture
                  )
                })
              end
            end
          end
        end

        # --
        def complex(doc)
          @args[:img] ||= {}
          args = @args.to_h(html: true, skip: HTML.skips)
          @args[:img][:src] = @args[:src]
          _, sources = kv

          doc.picture @args[:picture] do
            Array(sources).each do |w|
              w, d = w.to_s.split(%r!\s+!, 2)
              Integer(w)

              source({
                width: w,
                args: args.dup,
                src: path(width: w),
                density: d,
                doc: doc,
              })
            end

            doc.img(@args[:img])
          end
        end

        # --
        def path(width:)
          args_ = "#{args[:argv1]} magick:resize=#{width} @path"
          Tag.new("asset", args_, Liquid::ParseContext.new)
            .render(ctx)
        end

        # --
        def source(doc:, args:, src:, width:, density:)
          args.delete(:src)
          k, = kv

          args[:srcset] = "#{src} #{density || "#{width}w"}"
          args[:media]  = "(#{k}: #{width}px)" unless k == :width \
            || args[:media]

          doc.source args
        end

        # --
        def kv
          @kv ||= begin
            src = args[:srcset]

            out = [:"max-width", src[:"max-width"]] if src[:"max-width"]
            out = [:"min-width", src[:"min-width"]] if src[:"min-width"] && !out
            out = [:width, src[:width]] if src[:width] && !out

            out
          end
        end

        # --
        def proper_pic?
          args.key?(:srcset) && (
            args[:srcset].key?(:"max-width") ||
            args[:srcset].key?(:"min-width") ||
            args[:srcset].key?(:width))
        end

        # --
        def self.cleanup(s)
          s.gsub(%r!<(picture)>(.+)<\/\1>!) do |v|
            v.gsub(%r!</source>!, "")
          end
        end

        # --
        # {% img src src="" @pic %}
        # --
        def self.for?(args:, type:)
          return false unless super
          return false unless args.key?(:pic)
          true
        end
      end
    end
  end
end
