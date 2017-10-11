# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "fastimage"

module Jekyll
  module Assets
    class Drop < Liquid::Drop
      extend Forwardable::Extended
      IMG = %W("image/webp", "image/jpeg", "image/jpeg", "image/tiff",
        "image/bmp", "image/gif", "image/png")

      def initialize(path, jekyll: )
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

      def digest_path
        @sprockets.prefix_path(asset.digest_path)
      end

      def dimensions
        @dimensions ||= begin
          img = img?? FastImage.size(asset.filename.to_s) : []

          {
            width:  img.first,
            height: img.last,
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
