# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "fastimage"

module Jekyll
  module Assets
    module Liquid
      class Drop < ::Liquid::Drop
        extend Forwardable::Extended
        CONTENT_TYPE = %W(
          image/png
          image/jpeg
          image/gif
        )

        # --
        # @return [Jekyll::Assets::Liquid::Drop]
        # @param [Jekyll::Site] jekyll the Jekyll instance.
        # @param [String] path the path to the asset.
        # initialize creates a new instance
        # --
        def initialize(path, jekyll)
          @path = path
          @jekyll = jekyll
          @asset = nil
        end

        # --

        rb_delegate :digest_path,  to: :asset
        rb_delegate :logical_path, to: :asset
        rb_delegate :content_type, to: :asset
        rb_delegate :filename,     to: :asset
        rb_delegate :type,         to: :asset, \
          alias_of: :type

        # --
        # basename gives you the directory of the path.
        # @return [String]
        # --
        def basename
          File.basename(@path)
        end

        # --
        # integrity returns the files integrity string.
        # @return [String]
        # --
        def integrity
          return asset.integrity
        end

        # --
        # width returns an image width.
        # @return [Integer]
        # --
        def width
          if image?
            dimensions.first
          end
        end

        # --
        # height returns an image height.
        # @return [Integer]
        # --
        def height
          if image?
            dimensions.last
          end
        end

        # --
        # dimensions gives you the width and height.
        # @return [Array<Integer>]
        # --
        def dimensions
          if image?
            @dimensions ||= FastImage.size(asset.filename.to_s)
          end
        end

        # --
        # image? lets you know if the current asset is an image.
        # @return [true, false]
        # --
        private
        def image?
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
            found = @jekyll.sprockets.manifest.find(@path)
            if found
              then found.first
            end
          end
        end
      end
    end
  end
end
