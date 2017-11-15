# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"
require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class Pic < HTML
        content_types "image/webp"
        content_types "image/jpeg"
        content_types "image/tiff"
        content_types "image/svg+xml"
        content_types "image/bmp"
        content_types "image/gif"
        content_types "image/png"
        content_types "image/jpg"

        # --
        # rubocop:disable Metrics/AbcSize
        # @todo this should be reworked so we don't need to use
        #   tag to loop back in on ourselves.
        # --
        def run
          raise Tag::MixedArg, "@srcset", "@inline" if @asset.is_a?(Url)

          if @args[:srcset].is_a?(Array)
            bctx = Liquid::ParseContext.new
            @args[:picture] ||= {}

            Nokogiri::HTML::Builder.with(@doc) do |d|
              d.picture @args[:picture] do |p|
                @args[:srcset].each do |v|
                  args = "#{@args[:argv1]} @srcset #{v}"
                  p << Tag.new("asset", args, bctx).render(ctx)
                end

                p.img @args.to_h(html: true)
              end
            end
          else
            @args[:srcset] = @args[:src]
            Nokogiri::HTML::Builder.with(@doc) do |d|
              d.source(@args.to_h(html: true).tap do |o|
                o.delete(:src)
              end)
            end
          end
        end

        # --
        def self.cleanup(s)
          s.gsub(%r!<(picture)>(.+)<\/\1>!) do |v|
            v.gsub(%r!</source>!, "")
          end
        end

        # --
        def self.for?(args:, type:)
          super && !args[:inline] && args.key?(:srcset)
        end
      end
    end
  end
end
