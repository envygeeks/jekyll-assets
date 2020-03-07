# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

require "nokogiri"

module Jekyll
  module Assets
    class HTML
      class IMG < HTML
        content_types %r!^image/(?\!x-icon$)[a-zA-Z0-9\-_\+]+$!

        # --
        def run
          Nokogiri::HTML::Builder.with(doc) do |d|
            next complex_manual(d) if srcset_manual?
            next complex(d) if srcset_auto?
            d.img(args.to_h({
              html: true, skip: HTML.skips
            }))
          end
        end

        def complex_manual(doc)
          args[:srcset][:'1x'] = true
          img = doc.img args.to_h(skip: HTML.skips, html: true)
          args[:srcset].keys.grep(/^\d+x$/).sort.each do |key|
            path = Pathutil.new(args[:argv1])
            unless key == :'1x'
              path = path.sub_ext(
                atx_ext(
                  key, path
                )
              )
            end

            img["srcset"] ||= ""
            img["srcset"] += ", #{path_manual(path)} #{key}"
            img["srcset"] = img["srcset"]
              .gsub(%r!^,\s*!, "")
          end
        end

        def atx_ext(key, path)
          format('@%<size>s%<ext>s', {
            size: key, ext: path.extname
          })
        end

        def path_manual(path)
          t_args = "#{path} @path"
          t_args += " @optim" if args.key?(:optim)
          tag = Tag.new("asset", t_args, p_ctx)
          tag.render(ctx)
        end

        def complex(doc)
          img = doc.img args.to_h(html: true, skip: HTML.skips)
          Array(args[:srcset][:width]).each do |w|
            dimensions, density, type = w.to_s.split(%r!\s+!, 3)
            path = path_auto(dimensions: dimensions, type: type)

            img["srcset"] ||= ""
            img["srcset"] += ", #{path} "
            img["srcset"] += density || "#{dimensions}w"
            img["srcset"] = img["srcset"]
              .gsub(%r!^,\s*!, "")
          end
        end

        def path_auto(dimensions:, type: nil)
          t_args =  "#{args[:argv1]} @path"
          t_args += " magick:resize=#{dimensions}"
          t_args += " magick:format=#{type}" if type
          t_args += " @optim" if args.key?(:optim)
          tag = Tag.new("asset", t_args, p_ctx)
          tag.render(ctx)
        end

        def p_ctx
          Liquid::ParseContext.new
        end

        def srcset_auto?
          return false if @asset.content_type == 'image/svg+xml'
          args.key?(:srcset) && args[:srcset].key?(
            :width
          )
        end

        def srcset_manual?
          return false if @asset.content_type == 'image/svg+xml'
          args.key?(:srcset) && args[:srcset].keys.grep(
            /^\d+x$/
          )
        end

        #
        # @example {% asset src srcset="" %}
        # @example {% asset src %}
        #
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
