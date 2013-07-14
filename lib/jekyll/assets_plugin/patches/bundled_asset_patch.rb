# 3rd-party
require "sprockets"


module Jekyll
  module AssetsPlugin
    module Patches
      module BundledAssetPatch

        def jekyll_assets
          @processed_asset.jekyll_assets
        end

      end
    end
  end
end


Sprockets::BundledAsset.send :include, Jekyll::AssetsPlugin::Patches::BundledAssetPatch
