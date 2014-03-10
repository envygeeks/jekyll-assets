# stdlib
require "set"

module Jekyll
  module AssetsPlugin
    module Patches
      module ContextPatch
        def site
          self.class.instance_variable_get :@site
        end

        def jekyll_assets
          @jekyll_assets ||= Set.new
        end

        def asset_path(pathname, *args)
          return "" if pathname.to_s.strip.empty?
          asset = resolve(pathname.to_s[/^[^#?]+/]).to_s
          jekyll_assets << asset
          (site.asset_path asset, *args) + (pathname.to_s[/[#?].+/] || "")
        rescue Sprockets::FileNotFound
          raise Environment::AssetNotFound, pathname
        end
      end
    end
  end
end
