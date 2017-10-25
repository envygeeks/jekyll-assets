# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require "jekyll/assets"
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
            magick_format(img) if @args[:magick][:format]
            img.combine_options do |c|
              runners.each do |m|
                method(m).arity == 2 ? send(m, img, c) : send(m, c)
              end
            end

            img.write(@file)
            @file
          ensure
            if img
              img.destroy!
            end
          end

          def runners
            private_methods(true).select do |v|
              v =~ /^magick_/ && v != :magick_format
            end
          end

          private
          def magick_format(img)
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
            if @args[:magick].key?(:double)
              width = img.width*2
              height = img.height*2
            end
            if @args[:magick].key?(:half)
              width = img.width/2
              height = img.height/2
            end
            cmd.resize "#{width}x#{height}" if width && height
          end
        end
      end
    end
  end
end
