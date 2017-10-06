# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Plugins
      class ImgDefaults < Jekyll::Assets::Liquid::Default
        tags :img

        # --
        # alt provides the `alt=""` atttribute for your
        # images, by default it's simply just the logical
        # path of your image.  That's it.
        # @return [nil]
        # --
        def set_alt
          unless @args.key?(:alt)
            @args[:alt] = File.basename(@asset.logical_path)
          end
        end

        # --
        # dimensions provides a default dimension for your
        # images, we use `FastImage` to get this done at a quick
        # pace without having to do expensive tasks.
        # @return [nil]
        # --
        def set_dimensions
          @args[:width], @args[:height] = FastImage.
            size(@asset.filename.to_s)
        end

        # --
        def set_integrity
          @args[:integrity] = @asset.integrity
          @args[:crossorigin] = "anonymous" \
            unless @args[:crossorigin]
        end
      end
    end
  end
end
