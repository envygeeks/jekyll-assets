# 3rd-party
require "sprockets"

module Jekyll
  module AssetsPlugin
    module Patches
      module BundledAssetPatch
        def jekyll_assets
          @processed_asset.jekyll_assets
        end

        ::Sprockets::BundledAsset.send :include, self
      end
    end
  end
end
