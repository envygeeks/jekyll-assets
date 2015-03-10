# stdlib
require "set"

module Jekyll
  module Assets
    module Patches
      module ContextPatch
        def site
          self.class.instance_variable_get :@site
        end

        def jekyll_assets
          @jekyll_assets ||= Set.new
        end

        def asset_path(pathname, *args)
          pathname = pathname.to_s.strip

          return "" if pathname.empty?

          asset = resolve(pathname[/^[^#?]+/]).to_s
          jekyll_assets << asset

          site.asset_path(asset, *args) + (pathname[/[#?].+/] || "")
        rescue Sprockets::FileNotFound
          raise Environment::AssetNotFound, pathname
        end
      end
    end
  end
end
