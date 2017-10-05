# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Plugins
      class ImageDefaults < Jekyll::Assets::Liquid::Tag::Default
        tags :img, :image
        defaults({
          hello: "world"
        })

        # --
        # run runs the default we wish to set.
        # @return [nil]
        # --
        def run
          dimensions
          alt
        end

        # --
        # alt provides the `alt=""` atttribute for your
        # images, by default it's simply just the logical
        # path of your image.  That's it.
        # @return [nil]
        # --
        private
        def alt
          if @env.asset_config["img"]["alt"]
            unless @args.key?(:alt)
              @args[:alt] = @asset.logical_path
            end
          end
        end

        # --
        # dimensions provides a default dimension for your
        # images, we use `FastImage` to get this done at a quick
        # pace without having to do expensive tasks.
        # @return [nil]
        # --
        private
        def dimensions
          if @env.asset_config["img"]["dimensions"]
            wh = FastImage.size(@asset.filename.to_s)

            return unless wh
            @args[ :width] ||= wh.first
            @args[:height] ||= wh.last
          end
        end
      end
    end
  end
end
