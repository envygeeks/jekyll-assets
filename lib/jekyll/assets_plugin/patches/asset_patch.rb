# 3rd-party
require "sprockets"


module Jekyll
  module AssetsPlugin
    module Patches
      module AssetPatch

        def jekyll_assets
          []
        end

      end
    end
  end
end


Sprockets::Asset.send :include, Jekyll::AssetsPlugin::Patches::AssetPatch
