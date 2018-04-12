# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "jekyll/assets"

module Jekyll
  module Assets
    module Plugins
      class MiniMagick < Proxy
        content_types %r!^image/(?\!x-icon$)[a-zA-Z0-9\-_\+]+$!
        arg_keys :magick

        class SameType < StandardError
          def initialize(type)
            "Trying to convert #{type} to #{type} won't work."
          end
        end

        def process
          img = ::MiniMagick::Image.new(@file)
          magick_format(img) if @args[:magick][:format]
          img.combine_options do |c|
            @args[:magick].keys.reject { |k| k == :format }.each do |k|
              m = "magick_#{k}"

              if respond_to?(m, true)
                method(m).arity == 2 ? send(m, img, c) : send(m, c)
              end
            end
          end

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
          format = ".#{@args[:magick][:format].sub(%r!^\.!, '')}"
          ext = @env.mime_exts.find { |k, v| k == format || v == format }
          return unless ext

          ext, type = ext
          raise SameType, type if type == asset.content_type
          img.format(ext.sub(".", ""))
        end

        private
        def magick_transparency(cmd)
          if @args[:magick][:transparency]
            cmd.transparency @args[:magick][:transparency]
          end
        end

        private
        def magick_background(cmd)
          if @args[:magick].key?(:background)
            cmd.background @args[:magick][:background]
          end
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

        alias magick_double magick_preset_resize
        alias magick_quarter magick_preset_resize
        alias magick_half magick_preset_resize
      end
    end
  end
end
