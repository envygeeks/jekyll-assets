# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "mini_magick"

module Jekyll
  module Assets
    module Plugins
      class MiniMagick < Proxy
        types %r!^image\/[a-zA-Z]+$!
        args_key :magick

        # --
        def process
          img = ::MiniMagick::Image.open(@file)
          img.combine_options do |c|
            runners.each do |m|
              send(m, img, c)
            end
          end

          img.write(@file)
          @file
        ensure
          unless !img
            img.destroy!
          end
        end

        # --
        def runners
          private_methods(true).select do |v|
            v =~ /^magick_/
          end
        end

        # --
        private
        def magick_quality(_, cmd)
          if @args[:magick].key?(:quality)
            cmd.quality @args[:magick][:quality]
          end
        end

        # --
        private
        def magick_resize(_, cmd)
          if @args[:magick].key?(:resize)
            cmd.resize @args[:magick][:resize]
          end
        end

        # --
        private
        def magick_rotate(_, cmd)
          if @args[:magick].key?(:rotate)
            cmd.rotate @args[:magick][:rotate]
          end
        end

        # --
        private
        def magick_flip(_, cmd)
          if @args[:magick].key?(:flip)
            cmd.flip @args[:magick][:flip]
          end
        end

        # --
        private
        def magick_format(img, _)
          if @args[:magick].key?(:format)
            img.format @args[:magick][:format]
          end
        end

        # --
        private
        def magick_crop(_, cmd)
          if @args[:magick].key?(:crop)
            cmd.crop @args[:magick][:crop]
          end
        end

        # --
        private
        def magick_gravity(_, cmd)
          if @args[:magick].key?(:gravity)
            cmd.gravity @args[:magick][:gravity]
          end
        end

        # --
        private
        def magick_strip(_, cmd)
          cmd.strip
        end

        # --
        private
        def magick_preset_resize(img, cmd)
          width,height = img.width*2,img.height*2 if @args[:magick].key?(:"2x")
          width,height = img.width/2,img.height/2 if @args[:magick].
            key?(:"1/2")

          cmd.resize "#{width}x#{height}"
        end
      end
    end
  end
end
