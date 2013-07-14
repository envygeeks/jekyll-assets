# stdlib
require "set"


module Jekyll
  module AssetsPlugin
    module Patches
      module ContextPatch

        def site
          self.class.instance_variable_get :@site
        end


        def _jekyll_assets
          @_jekyll_assets ||= Set.new
        end


        def asset_path path, *args
          _jekyll_assets << resolve(path).to_s
          site.asset_path path, *args
        rescue Sprockets::FileNotFound
          raise Environment::AssetNotFound, path
        end

      end
    end
  end
end
