# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "jekyll/assets"
require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class Pic < HTML
        types "image/webp", "image/jpeg", "image/jpeg", "image/tiff",
          "image/bmp", "image/gif", "image/png",
            "image/svg+xml"

        def run
          if @args[:srcset].is_a?(Array); @args[:picture] ||= {}
            ctx1, ctx2 = Liquid::ParseContext.new, context
            Nokogiri::HTML::Builder.with(@doc) do |d|
              d.picture @args[:picture] do |p|
                p.img @args.to_html(hash: true)
                @args[:srcset].each do |v|
                  p << Tag.new("asset", "#{@args[:argv1]} @srcset #{v}",
                    ctx1).render(ctx2)
                end
              end
            end
          else
            @args[:srcset] = @args[:src]
            Nokogiri::HTML::Builder.with(@doc) do |d|
              d.source(@args.to_html(hash: true).tap do |o|
                o.delete(:src)
              end)
            end
          end
        end

        def self.cleanup(s)
          s.gsub(/<(picture)>(.+)<\/\1>/) do |v|
            v.gsub(/<\/source>/, "")
          end
        end

        def self.for?(args:, type:)
          super && !args[:inline] && args.key?(:srcset)
        end

        private
        def context
          @struct ||= Struct.new(:registers)
          @struct.new({
            :site => @env.jekyll
          })
        end
      end
    end
  end
end
