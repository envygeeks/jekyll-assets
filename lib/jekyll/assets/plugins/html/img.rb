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
            next automatic(html) if responsive? && automatic?
            next discovery(html) if responsive? && discovery?
            build_img(
              html
            )
          end
        end

        def discovery(html)
          srcset(html, scales.each_with_object({}) do |scale, obj|
            asset = env.find_asset(scaled_name(scale))
            next unless asset

            obj.update({
              scale => begin
                args = self.args.dup
                args.update(path: true, argv1: asset.filename, src: nil)
                tag = Tag.new('asset', args, parse_ctx)
                tag.render(
                  ctx
                )
              end
            })
          end)
        end

        def path
          Pathutil.new(
            asset.filename
          )
        end

        #
        # add @<n>x to the file
        # @param scale [Integer] the scale
        # @return [Pathutil]
        #
        def scaled_name(scale)
          return path if scale == 1
          path.sub_ext(format('@%<scale>sx%<ext>s', {
            scale: scale,
            ext: path.send(
              :extname
            )
          }))
        end

        # Generate automatic sizes
        # @note the asset is considered the max width
        # @note this poses a potential problem right now
        #   in that if your min is smaller than your potential
        #   1x you might never get a 1x at all.
        # @return [nil]
        #
        def automatic(html)
          srcset(html, widths.each_with_object({}) do |(scale, width), obj|
            obj.update({
              scale => begin
                args = self.args.dup
                args.update({
                  path: true,
                  magick: {
                    resize: format('%<width>dx', {
                      width: width
                    })
                  }
                })

                tag = Tag.new('asset', args, parse_ctx)
                tag.render(
                  ctx
                )
              end
            })
          end)
        end

        def srcset(html, scales)
          img = build_img(html)
          scales = scales.sort.to_h
          img[:src] = scales.first[1]

          if scales.size >= 2
            img[:srcset] = scales.map do |scale, src|
              next if scale == scales.first[0]
              format('%<src>s %<scale>sx', {
                scale: scale,
                src: src
              })
            end.compact.join(', ')
          end

          img
        end

        def widths
          return upscaled_widths if upscale?

          scales, out = self.scales, {}
          self.scales.reverse.map do |div|
            width = width_of / div
            if above_min?(width)
              out.update({
                scales.shift => width.to_i
              })
            end
          end

          if out.empty?
            then out.update({
              1 => width_of
            })
          end

          out
        end

        def build_img(html)
          html.img(args.to_h(
            html: true, skip: HTML.skips
          ))
        end

        def upscaled_widths
          args.dig(:responsive, :upscale) || env.asset_config.dig(
            :responsive, :automatic_upscale
          )
        end

        def upscale?
          args.dig(:responsive, :upscale) || env.asset_config.dig(
            :responsive, :automatic_upscale
          )
        end

        #
        # All of the defined scales
        # @note you can either define them in the tag
        #   or you can define tem in the config, not both
        # @return [Array]
        #
        def scales
          raw_scales.map do |scale|
            scale =~ %r!\.! \
              ? scale.to_s.to_f
              : scale.to_s.to_i
          end.sort
        end

        def raw_scales
          Array(
            args.dig(:responsive, :scales) ||
            env.asset_config.dig(
              :responsive, :scales
            )
          )
        end

        #
        # Get the current width of the asset
        # @return [Integer]
        #
        def width_of(asset = self.asset)
          img = FastImage.size(asset.filename)
          img.fetch(
            0
          )
        end

        #
        # The minimum acceptable width as defined in the
        #   tag, or inside of the configuration
        # @return [Integer]
        #
        def min_width
          args.dig(:responsive, :min_width) ||
            env.asset_config.dig(
              :responsive, :automatic_min_width
            )
        end

        #
        # above min makes sure that an asset is
        #   above the minimum size, so we can skip
        #   or just stop building, or not build
        # @param asset [Sprockets::Asset, Integer]
        # @return [true, false]
        #
        def above_min?(asset = self.asset)
          return asset > min_width if asset.is_a?(Numeric)
          min_width < width_of(
            asset
          )
        end

        #
        # should we be doing automatic conversion?
        # @note you must also be *above* the min width or 0
        # @note min width does not apply to tags
        # @return [true, false]
        #
        def automatic?
          args.dig(:responsive, :automatic) || (
            above_min? && env.asset_config.dig(
              :responsive, :automatic
            )
          )
        end

        #
        # should we be doing discovery?
        # @return [true, false]
        #
        def discovery?
          args.dig(:responsive, :discovery) ||
          env.asset_config.dig(
            :responsive, :discovery
          )
        end

        #
        # @see responsive_tag?
        # responsive is true if you are having a
        #   responsive tag, or you have set up the config
        #   to use automatic sizing, or discovery
        # @return [true, false]
        #
        def responsive?
          return false if asset.is_a?(Url)
          return false if asset.content_type == 'image/webp'
          return false if asset.content_type == 'image/svg+xml'
          automatic? || discovery? &&
            false != args[
              :responsive
            ]
        end

        #
        # the parse context
        # @note this can be a new instance always
        # @return Liquid::ParseContext
        #
        def parse_ctx
          Liquid::ParseContext.new
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

    Hook.register :config, :before_merge do |cfg|
      cfg.deep_merge!({
        responsive: {
          automatic: false,
          automatic_min_width: 128,
          automatic_scales: %i(1x 1.5x 2x),
          discovery_scales: %i(1x 1.5x 2x),
          automatic_upscale: false,
          discovery: false,
          optim: false
        }
      })
    end
  end
end
