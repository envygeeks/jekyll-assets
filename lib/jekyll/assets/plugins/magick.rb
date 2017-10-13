# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

try_require "mini_magick" do
  module Jekyll
    module Assets
      module Plugins
        class MiniMagick < Proxy
          args_key :magick
          types "image/webp", "image/jpeg", "image/jpeg", "image/tiff",
            "image/bmp", "image/gif", "image/png",
              "image/svg+xml"

          def process
            img = ::MiniMagick::Image.open(@file)
            format_and_write(img) if @args[:magick][:format]
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

          def runners
            private_methods(true).select do |v|
              v =~ /^magick_/
            end
          end

          private
          def format_and_write(img)
            new_ = nil

            exts = @env.mime_exts.select do |k, v|
              k == @args[:magick][:format] ||
              v == @args[:magick][:format]
            end

            if exts.first
              new_ = @file.sub_ext(exts.first[0])
              img.format(exts.first[0].sub(".", ""))
              @file.cp(new_)
              @file.rm
              @file =
                new_
            end

            img.write(@file)
          end

          private
          def magick_compress(_, cmd)
            if @args[:magick].key?(:compress)
              cmd.compress @args[:magick][:compress]
            end
          end

          private
          def magick_quality(_, cmd)
            if @args[:magick].key?(:quality)
              cmd.quality @args[:magick][:quality]
            end
          end

          private
          def magick_resize(_, cmd)
            if @args[:magick].key?(:resize)
              cmd.resize @args[:magick][:resize]
            end
          end

          private
          def magick_rotate(_, cmd)
            if @args[:magick].key?(:rotate)
              cmd.rotate @args[:magick][:rotate]
            end
          end

          private
          def magick_flip(_, cmd)
            if @args[:magick].key?(:flip)
              cmd.flip @args[:magick][:flip]
            end
          end

          private
          def magick_crop(_, cmd)
            if @args[:magick].key?(:crop)
              cmd.crop @args[:magick][:crop]
            end
          end

          private
          def magick_gravity(_, cmd)
            if @args[:magick].key?(:gravity)
              cmd.gravity @args[:magick][:gravity]
            end
          end

          private
          def magick_strip(_, cmd)
            cmd.strip
          end

          private
          def magick_preset_resize(img, cmd)
            width,height = img.width*2,img.height*2 if @args[:magick].key?(:double)
            width,height = img.width/2,img.height/2 if @args[:magick].key?(:half)
            cmd.resize "#{width}x#{height}"
          end
        end
      end
    end
  end
end
