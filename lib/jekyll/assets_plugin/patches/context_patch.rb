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


        def asset_path pathname, *args
          jekyll_assets << resolve(pathname.to_s[/^[^#?]+/]).to_s
          site.asset_path pathname, *args
        rescue Sprockets::FileNotFound
          raise Environment::AssetNotFound, pathname
        end

      end
    end
  end
end
