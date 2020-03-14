# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

require "liquid/drop"
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

      # --
      # Register the drop creator.
      # @return [nil]
      # --
      public
      def self.register
        Jekyll::Hooks.register :site, :pre_render do |s, h|
          if s.sprockets
            h["assets"] = s.sprockets.to_liquid_payload
          end
        end
      end
    end
  end
end
