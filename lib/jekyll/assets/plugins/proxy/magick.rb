# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "jekyll/assets"

module Jekyll
  module Assets
    module Plugins
      class MiniMagick < Proxy
        arg_keys :magick
        content_types "image/webp"
        content_types "image/jpeg"
        content_types "image/svg+xml"
        content_types "image/tiff"
        content_types "image/bmp"
        content_types "image/gif"
        content_types "image/png"

        class SameType < StandardError
          def initialize(type)
            "Trying to convert #{type} to #{type} won't work."
          end
        end

        def process
          img = ::MiniMagick::Image.open(@file)
          magick_format(img) if @args[:magick][:format]
          img.combine_options do |c|
            runners.each do |m|
              method(m).arity == 2 ? send(m, img, c) : send(m, c)
            end
          end

          img.write(@file)
          @file
        ensure
          img&.destroy!
        end

        def runners
          private_methods(true).select do |v|
            v =~ %r!^magick_! && v != :magick_format
          end
        end

        private
        def magick_format(img)
          exts = @env.mime_exts.select do |k, v|
            k == @args[:magick][:format] || v == @args[:magick][:format]
          end

          if exts.first
            ext, type = exts.first
            new_ = @file.sub_ext(ext)
            raise SameType, type if type == asset.content_type
            img.format(ext.sub(".", ""))
            @file.cp(new_)
            @file.rm
            @file =
              new_
          end

          img.write(@file)
        end

        private
        def magick_compress(cmd)
          if @args[:magick].key?(:compress)
            cmd.compress @args[:magick][:compress]
          end
        end

        private
        def magick_quality(cmd)
          if @args[:magick].key?(:quality)
            cmd.quality @args[:magick][:quality]
          end
        end

        private
        def magick_resize(cmd)
          if @args[:magick].key?(:resize)
            cmd.resize @args[:magick][:resize]
          end
        end

        private
        def magick_rotate(cmd)
          if @args[:magick].key?(:rotate)
            cmd.rotate @args[:magick][:rotate]
          end
        end

        private
        def magick_flip(cmd)
          if @args[:magick].key?(:flip)
            cmd.flip @args[:magick][:flip]
          end
        end

        private
        def magick_crop(cmd)
          if @args[:magick].key?(:crop)
            cmd.crop @args[:magick][:crop]
          end
        end

        private
        def magick_gravity(cmd)
          if @args[:magick].key?(:gravity)
            cmd.gravity @args[:magick][:gravity]
          end
        end

        private
        def magick_strip(cmd)
          cmd.strip
        end

        private
        def magick_preset_resize(img, cmd)
          # rubocop:disable Metrics/LineLength
          width, height = img.width * 2, img.height * 2 if @args[:magick].key?(:double)
          width, height = img.width / 2, img.height / 2 if @args[:magick].key?(:half)
          cmd.resize "#{width}x#{height}" if width && height
        end
      end
    end
  end
end
