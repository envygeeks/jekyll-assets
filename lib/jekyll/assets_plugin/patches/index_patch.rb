# 3rd-party
require "sprockets"


module Jekyll
  module AssetsPlugin
    module Patches
      module IndexPatch

        def self.included base
          base.class_eval do
            alias_method :find_asset_without_jekyll, :find_asset
            alias_method :find_asset, :find_asset_with_jekyll
          end
        end


        def find_asset_with_jekyll path, options = {}
          asset = find_asset_without_jekyll path, options
          @environment.site.bundle_asset! asset if asset and options[:bundle]
          asset
        end

      end
    end
  end
end


Sprockets::Index.send :include, Jekyll::AssetsPlugin::Patches::IndexPatch
