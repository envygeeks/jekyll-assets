# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require "liquid/drop"
require "forwardable/extended"
require "fastimage"

module Jekyll
  module Assets
    class Drop < Liquid::Drop
      extend Forwardable::Extended
      IMG = %W(image/webp image/jpeg image/jpeg image/tiff
        image/bmp image/gif image/png)

      def initialize(path, jekyll:)
        @path = path
        @sprockets = jekyll.sprockets
        @jekyll = jekyll
        @asset = nil
      end

      rb_delegate :width,        to: :dimensions, type: :hash
      rb_delegate :height,       to: :dimensions, type: :hash
      rb_delegate :basename,     to: :File, args: :@path
      rb_delegate :content_type, to: :asset
      rb_delegate :integrity,    to: :asset
      rb_delegate :filename,     to: :asset

      # --
      # @todo this needs to move to `_url`
      # @return [String] the prefixed and digested path.
      # The digest path.
      # --
      def digest_path
        @sprockets.prefix_url(asset.digest_path)
      end

      # --
      # Image dimensions if the asest is an image.
      # @return [Hash<Integer,Integer>] the dimensions.
      # @note this can break easily.
      # --
      def dimensions
        @dimensions ||= begin
          img = img?? FastImage.size(asset.filename.to_s) : []

          {
            width:  img.first,
            height: img.last
          }
        end
      end

      private
      def img?
        if asset.content_type
          IMG.include?(asset.content_type)
        end
      end

      private
      def asset
        @asset ||= begin
          @sprockets.find_asset!(@path)
        end
      end
    end
  end
end
