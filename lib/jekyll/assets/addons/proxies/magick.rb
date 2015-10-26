try_require "mini_magick" do
  module Jekyll
    module Assets
      module Liquid
        class Tag
          module Proxies

            # -----------------------------------------------------------------
            # @see https://github.com/minimagick/minimagick#usage -- All but
            #   the boolean @ options are provided by Minimagick.
            # -----------------------------------------------------------------

            class Magick
              attr_reader :asset, :path, :opts
              class DoubleResizeError < RuntimeError
                def initialize
                  "Both resize and @*x provided, this is not supported."
                end
              end

              # ---------------------------------------------------------------

              def initialize(asset, opts)
                @asset, @path, @opts = asset, asset.filename, opts
              end

              # ---------------------------------------------------------------

              def process
                img = MiniMagick::Image.open(path)
                private_methods(true).select { |v| v =~ /\Amagick_/ }.each do |method|
                  send(method, img)
                end

                img.write(
                  path
                )
              end

              # ---------------------------------------------------------------

              private
              def magick_quality(img)
                if opts.has_key?(:quality)
                  img.quality opts.fetch(:quality)
                end
              end

              # ---------------------------------------------------------------

              private
              def magick_resize(img)
                if opts.has_key?(:resize) && (opts.has_key?(:"2x") || \
                      opts.has_key?(:"4x") || opts.has_key?(:half))
                  raise DoubleResizeError

                elsif opts.has_key?(:resize)
                  img.resize opts.fetch(:resize)
                end
              end

              # ---------------------------------------------------------------

              private
              def magick_rotate(img)
                if opts.has_key?(:rotate)
                  img.rotate opts.fetch(:rotate)
                end
              end

              # ---------------------------------------------------------------

              private
              def magick_flip(img)
                if opts.has_key?(:flip)
                  img.flip opts.fetch(:flip)
                end
              end

              # ---------------------------------------------------------------

              private
              def magick_crop(img)
                if opts.has_key?(:crop)
                  img.crop opts.fetch(:crop)
                end
              end

              # ---------------------------------------------------------------

              private
              def magick_preset_resize(img)
                return unless opts.has_key?(:"2x") || opts.has_key?(:"4x") || opts.has_key?(:half)
                width, height = img.width * 2, img.height * 2 if opts.has_key?(:"2x")
                width, height = img.width * 4, img.height * 4 if opts.has_key?(:"4x")
                width, height = img.width / 2, img.height / 2 if opts.has_key?(:half)
                img.resize "#{width}x#{height}"
              end
            end

            add_by_class Magick, :magick, :img, [
              "resize",
              "quality",
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
  end
end
