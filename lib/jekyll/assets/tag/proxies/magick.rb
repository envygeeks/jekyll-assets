module Jekyll
  module Assets
    class Tag
      module Proxies

        # @see https://github.com/minimagick/minimagick#usage -- All but
        #   the boolean @ options are provided by Minimagick.

        class Magick
          attr_reader :asset, :path, :opts
          class DoubleResizeError < RuntimeError
            def initialize
              "Both resize and @2x provided, this is not supported."
            end
          end

          def initialize(asset, opts)
            @asset, @path, @opts = asset, asset.filename, opts
          end

          def process
            img = MiniMagick::Image.open(path)
            private_methods(true).select { |v| v =~ /\Amagick_/ }.each do |k|
              send(k, img)
            end

            img.write(
              path
            )
          end

          private
          def magick_resize(img)
            if opts[:resize] && opts[:"@2x"]
              raise DoubleResizeError

            elsif @opts[:resize]
              img.resize opts[:resize]
            end
          end

          private
          def magick_format(img)
            if opts[:format]
              img.format opts[:format]
            end
          end

          private
          def magick_rotate(img)
            if opts[:rotate]
              img.rotate opts[:rotate]
            end
          end

          private
          def magick_flip(img)
            if opts[:flip]
              img.flip opts[:flip]
            end
          end

          private
          def magick_crop(img)
            if opts[:crop]
              img.crop opts[:crop]
            end
          end

          private
          def magick_preset_resize(img)
            return unless opts[:"2x"] || opts[:"4x"] || opts[:half]
            width, height = img.width * 2, img.height * 2 if opts[:"2x"]
            width, height = img.width * 4, img.height * 4 if opts[:"4x"]
            width, height = img.width / 2, img.height / 2 if opts[:half]
            img.resize "#{width}x#{height}"
          end
        end

        add Magick, :magick, :img, [
          "resize",
          "format",
          "rotate",
          "crop",
          "flip",
          "@2x",
          "@4x",
          "@half"
        ]
      end
    end
  end
end
