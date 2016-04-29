# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "fastimage"

module Jekyll
  module Assets
    module Liquid
      class Drop < ::Liquid::Drop
        extend Forwardable
        def initialize(path, jekyll)
          @path = path
          @jekyll = jekyll
          @asset = nil
        end

        # --------------------------------------------------------------------

        def_delegator :asset, :digest_path
        def_delegator :asset, :logical_path
        def_delegator :asset, :content_type, :type
        def_delegator :asset, :content_type
        def_delegator :asset, :filename

        # --------------------------------------------------------------------

        def basename
          File.basename(@path)
        end

        # --------------------------------------------------------------------

        def integrity
          return asset.integrity
        end

        # --------------------------------------------------------------------

        def width
          if image?
            dimensions.first
          end
        end

        # --------------------------------------------------------------------

        def height
          if image?
            dimensions.last
          end
        end

        # --------------------------------------------------------------------

        def dimensions
          if image?
            @dimensions ||= FastImage.new(asset.filename).size
          end
        end

        # --------------------------------------------------------------------

        private
        def image?
          %W(image/png image/jpeg image/gif).include?(
            asset.content_type
          )
        end

        # --------------------------------------------------------------------

        private
        def asset
          @asset ||= @jekyll.sprockets.manifest.find(@path) \
            .first
        end
      end
    end
  end
end
