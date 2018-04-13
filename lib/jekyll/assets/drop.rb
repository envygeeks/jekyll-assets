# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "liquid/drop"
require "forwardable/extended"
require "fastimage"

module Jekyll
  module Assets
    class Drop < Liquid::Drop
      extend Forwardable::Extended
      def initialize(path, jekyll:)
        @path = path.to_s
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
          img = FastImage.size(asset.filename.to_s)

          {
            "width"  => img[0],
            "height" => img[1],
          }
        rescue => e
          Logger.error e
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
