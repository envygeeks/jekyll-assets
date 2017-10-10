# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "fastimage"

module Jekyll
  module Assets
    class Drop < Liquid::Drop
      extend Forwardable::Extended
      CONTENT_TYPES = %W(
        image/png
        image/svg+xml
        image/jpeg
        image/gif
      )

      # --
      # initialize creates a new instance
      # @param [Jekyll::Site] jekyll the Jekyll instance.
      # @param [String] path the path to the asset.
      # @return [Drop]
      # --
      def initialize(path, jekyll: )
        @path = path
        @jekyll = jekyll
        @asset = nil
      end

      # --

      rb_delegate :width,        to: :dimensions, type: :hash
      rb_delegate :height,       to: :dimensions, type: :hash
      rb_delegate :basename,     to: :File, args: :@path
      rb_delegate :digest_path,  to: :asset
      rb_delegate :logical_path, to: :asset
      rb_delegate :content_type, to: :asset
      rb_delegate :integrity,    to: :asset
      rb_delegate :filename,     to: :asset

      # --
      # dimensions gives you the width and height.
      # @return [Array<Integer>]
      # --
      def dimensions
        @dimensions ||= begin
          img = img?? FastImage.size(asset.filename.to_s) : []

          {
            width:  img.first,
            height: img.last,
          }
        end
      end

      # --
      # image? lets you know if the current asset is an image.
      # @return [true, false]
      # --
      private
      def img?
        if asset.content_type
          CONTENT_TYPES.include?(asset.content_type)
        end
      end

      # --
      # asset returns the asset based on the path.
      # @return [Sprockets::Asset]
      # --
      private
      def asset
        @asset ||= begin
          out = @jekyll.sprockets.manifest.find(@path).first
          unless out
            raise Errors::AssetNotFound, @path
          end

          out
        end
      end
    end
  end
end
