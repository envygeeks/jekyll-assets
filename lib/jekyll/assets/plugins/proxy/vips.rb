# Frozen-string-literal: true
# Copyright: 2019 - MIT License
# Author: Andrew Heberle
# Encoding: utf-8

module Jekyll
  module Assets
    module Plugins
      class Vips < Proxy
        content_types %r!^image/(?\!x-icon$)[a-zA-Z0-9\-_\+]+$!
        arg_keys :vips

        # handles the vips process
        # by default images are stripped
        # some defaults for certain image formats are set as follows:
        #  JPEG = interlace (true), optimized encoding (true)
        #  WEBP = lossless (via "vips:lossless"), near_lossless (via
        #    "vips:near_lossless")
        #  PNG  = compression (via "vips:compression=X"), interlace (via
        #    "vips:interlace"
        #
        # libvips builds a "pipeline" of processes which are executed on write
        #
        # write_opts is added to and then used via "img.write_to_buffer"

        def process
          in_file = @file
          in_ext = in_file.extname

          img = ::Vips::Image.new_from_file in_file

          if @args[:vips].key?(:format)
            format = ".#{@args[:vips][:format].sub(%r!^\.!, '')}"
            ext = @env.mime_exts.find { |k, v| k == format || v == format }
            out_ext, type = ext
          else
            out_ext = in_ext
          end

          write_opts = {}

          case out_ext
          when ".jpg", ".jpeg"
            write_opts[:interlace] = true
            write_opts[:optimize_coding] = true
          when ".webp"
            write_opts[:lossless] = @args[:vips].key?(:lossless)
            write_opts[:near_lossless] = @args[:vips].key?(:near_lossless)
          when ".png"
            if @args[:vips].key?(:compression)
              write_opts[:compression] = @args[:vips][:compression]
            end
            write_opts[:interlace] = @args[:vips].key?(:interlace)
          end

          if @args[:vips].key?(:quality)
            write_opts = vips_quality(write_opts)
          end

          if @args[:vips].key?(:strip)
            write_opts[:strip] = vips_strip(write_opts)
          else
            write_opts[:strip] = true
          end

          if @args[:vips].key?(:resize)
            img = vips_resize(img)
          elsif @args[:vips].key?(:double)
            img = vips_double(img)
          elsif @args[:vips].key?(:half)
            img = vips_half(img)
          end

          out_file = in_file.sub_ext(out_ext)
          buf = img.write_to_buffer out_ext, write_opts
          
          @file.binwrite(buf)

          if @file != out_file
            @file.rename(out_file)
          end

          out_file
        end

        # vips:compression=<compression>
        # sets the compression for the operation
        # only makes sense for losseless image formats
        private
        def vips_compression(opts)
          opts[:compression] = @args[:vips][:compression].to_i
          opts
        end

        # vips:quality=<quality>
        # sets the quality for the operation
        # only makes sense for lossy image formats
        private
        def vips_quality(opts)
          opts[:Q] = @args[:vips][:quality].to_i
          opts
        end

        # vips:strip
        # strips metadata from an image
        private
        def vips_strip(opts)
          opts[:strip] = @args[:vips][:strip]
          opts
        end

        # vips:resize='<width>[x<height>]'
        # resizes an image via vips
        # will resize to  sepcified width, height or both
        # can also crop to that size or fill "extra" space
        # extra space is filled with blurred version of image
        # that is expanded to fill space
        private
        def vips_resize(img)
          resize_opts = {}
          if @args[:vips][:resize].is_a? Integer
            width = @args[:vips][:resize]
          else
            if @args[:vips][:resize].include? "x"
              width, height = @args[:vips][:resize].split("x")
              if width == "" or width == nil
                width = 0
              else
                width = width.to_i
              end
              if height == "" or height == nil
                height = width
              else
                height = height.to_i
                resize_opts[:height] = height
                if width == 0
                  width = height.to_i
                end
              end
            else
              width = @args[:vips][:resize].to_i
            end
            if @args[:vips].key?(:crop)
              if @args[:vips][:crop] == "fill"
                do_fill = true
              else
                do_fill = false
                resize_opts[:crop] = @args[:vips][:crop]
              end
            end
          end

          newimg = img.thumbnail_image width, resize_opts

          if do_fill
            actual_width = newimg.width
            actual_height = newimg.height
            if actual_width != width || actual_height != height
              if actual_width > actual_height
                ratio = actual_width.to_f / actual_height.to_f
                crop_y = 0
              elsif actual_height > actual_width
                crop_x = 0
                ratio = actual_height.to_f / actual_width.to_f
              else
                ratio = 1
              end
              blur_w = (ratio * actual_width).round
              blur_h = (ratio * actual_height).round
              crop_x = (blur_w - width) / 2
              crop_y = (blur_h - height) / 2
              blur = img.thumbnail_image blur_w, height: blur_h
              blur = blur.gaussblur 10
              x_origin = ((blur.width - actual_width) / 2).floor
              y_origin = ((blur.height - actual_height) / 2).floor
              newimg = blur.draw_image newimg, x_origin, y_origin
              if crop_x + width > blur.width || crop_y + height > blur.height
                width = width - 1
                height = height - 1
              end
              newimg = newimg.extract_area crop_x, crop_y, width, height
            end
          end

          newimg
        end

        # vips:double
        # doubles the size of the image
        private
        def vips_double(img)
          newimg = img.resize(2)
          newimg
        end

        # vips:half
        # halves the size of the image
        private
        def vips_half(img)
          newimg = img.resize(0.5)
          newimg
        end

      end
    end
  end
end
