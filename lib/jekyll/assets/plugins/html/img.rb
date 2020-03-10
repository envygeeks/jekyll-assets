# Frozen-string-literal: true
# rubocop:disable Layout/MultilineOperationIndentation
# Copyright: 2012 - 2020 - ISC License
# Author: Jordon Bedwell
# Encoding: utf-8

require 'nokogiri'

module Jekyll
  module Assets
    class HTML
      class IMG < HTML
        content_types %r@^image/(?!x-icon$)[a-zA-Z0-9\-_+]+$@

        def run
          Nokogiri::HTML::Builder.with(doc) do |html|
            next responsive(html) if responsive?
            html.img(args.to_h({
              html: true, skip: HTML.skips
            }))
          end
        end

        #
        # create a responsive image
        # @param html [Nokogiri::HTML::Fragment] the document
        # @return [void]
        #
        def responsive(html)
          width = sizeof(asset)[:w]
          img = html.img(args.to_h(html: true, skip: HTML.skips))
          img[:srcset] ||= ''

          paths = scales.zip(scales.reverse).map do |(scale, divide)|
            existing = env.find_asset(scaled_name(scale))
            unless existing
              expected_width = width / divide
              if expected_width < min_width
                next
              end
            end

            args = self.args.dup
            args[:argv1] = existing.filename if existing
            args[:path] = true

            unless existing
              args[:magick] = {
                resize: format('%<width>dx', {
                  width: width / divide
                })
              }
            end

            tag = Tag.new('asset', args, p_ctx)
            tag.render(
              ctx
            )
          end

          paths, o_scales = correct_scales(paths, scales)
          to_srcset(paths,
            scales: o_scales,
            img: img
          )
        end

        def to_srcset(paths, scales:, img:)
          scales = scales.zip(paths).map do |(scale, path)|
            format('%<path>s %<scale>sx', {
              scale: scale, path: path
            })
          end

          # Add them to the image
          img[:srcset] = scales.join(
            ', '
          )
        end

        def correct_scales(paths, scales)
          o_scales, paths = scales, paths.compact
          if paths.size < scales.size
            o_scales = scales.reverse[
              0...paths.size
            ].reverse
          end

          [
            paths,
            o_scales
          ]
        end

        def scaled_name(scale)
          path = Pathutil.new(asset.filename)
          path.sub_ext(format('@%<scale>sx%<ext>s', {
            scale: scale,
            ext: path.send(
              :extname
            )
          }))
        end

        #
        # the max width
        # @note this can be set on the tag
        #   or it can be set on the config
        # @return [Integer]
        #
        def min_width
          args.dig(:srcset, :'min-width') ||
          args.dig(:srcset, :'min_width') ||
          env.asset_config.dig(
            :responsive, :min_width
          )
        end

        #
        # the min width
        # @note this can vbe set on the tag
        #   or it can be set on the config
        # @return [Integer]
        #
        def max_width
          args.dig(:srcset, :'max-width') ||
          args.dig(:srcset, :'max_width') ||
          env.asset_config.dig(
            :responsive, :min_width
          )
        end

        def scales
          scales = args.dig(:srcset)&.keys&.grep(%r!^\d+x$!)
          scales = env.asset_config[:responsive][:scales] if !scales || scales.empty?
          scales.sort.reverse.map do |scale|
            Integer(
              scale.to_s.gsub(
                %r!^@|x$!, ''
              )
            )
          end
        end

        #
        # the parse context
        # @note this can be a new instance always
        # @return Liquid::ParseContext
        #
        def p_ctx
          Liquid::ParseContext.new
        end

        #
        # Get the size of an asset
        # @return [Hash]
        #
        def sizeof(asset = self.asset)
          f_name = asset.respond_to?(:filename) ? asset.filename : asset
          img = FastImage.size(f_name.to_s)

          {
            w: img[0],
            h: img[
              1
            ]
          }
        end

        #
        # Are we responsive?
        # @note you can be responsive if you set
        #   responsive automatic to true, and set a width,
        #   or you use srcset on the tag, and you set
        #   width or @{n} so we can work with that
        # @return [true, false]
        #
        def responsive?
          return false if env.external?(asset)
          return false if asset.content_type == 'image/svg+xml'
          env.asset_config[:responsive][:automatic] ||
            userdef_width? ||
            userdef_scale?
        end

        #
        # Are we a srcset:width?
        # @return [true, false]
        # @example {% asset
        #   example.png
        #   srcset:width=100
        #   srcset:width:200
        # %}
        def userdef_width?
          return false if @asset.content_type == 'image/svg+xml'
          args.key?(:srcset) && args[:srcset].key?(
            :width
          )
        end

        #
        # Are we scaling based on the user?
        # @return [true, false]
        # @example {%
        #   example.png
        #   srcset:1x
        #   srcset:2x
        # %}
        #
        def userdef_scale?
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
              type == 'image/svg+xml'

          true
        end
      end
    end
  end
end

Jekyll::Assets::Hook.register :config, :before_merge do |cfg|
  cfg.deep_merge!({
    responsive: {
      max_width: 5000,
      automatic: true,
      min_width: 0,
      scales: %i(
        1x
        2x
        3x
      )
    }
  })
end
