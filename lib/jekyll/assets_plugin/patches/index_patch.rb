# 3rd-party
require "sprockets"

module Jekyll
  module AssetsPlugin
    module Patches
      module IndexPatch
        def self.included(base)
          base.class_eval do
            alias_method :__orig_find_asset, :find_asset
            alias_method :find_asset, :__wrap_find_asset
          end
        end

        def __wrap_find_asset(path, options = {})
          __orig_find_asset(path, options).tap do |asset|
            asset.instance_variable_set :@site, @environment.site if asset
          end
        end
      end
    end
  end
end

Sprockets::Index.send :include, Jekyll::AssetsPlugin::Patches::IndexPatch
