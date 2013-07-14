# stdlib
require "set"


# 3rd-party
require "sprockets"


module Jekyll
  module AssetsPlugin
    module Patches
      module ProcessedAssetPatch

        def self.included base
          base.class_eval do
            attr_reader :jekyll_assets

            alias_method :__jekyll_orig_build_dependency_paths, :build_dependency_paths
            alias_method :build_dependency_paths, :__jekyll_wrap_build_dependency_paths

            alias_method :__jekyll_orig_init_with, :init_with
            alias_method :init_with, :__jekyll_wrap_init_with

            alias_method :__jekyll_orig_encode_with, :encode_with
            alias_method :encode_with, :__jekyll_wrap_encode_with
          end
        end


        def __jekyll_wrap_build_dependency_paths environment, context
          @jekyll_assets = Set.new

          context._jekyll_assets.each do |path|
            @jekyll_assets << path

            if path != pathname.to_s
              asset = environment.find_asset(path) rescue nil

              if asset and asset.respond_to? :jekyll_assets
                asset.jekyll_assets.each{ |p| @jekyll_assets << p }
              end
            end
          end

          __jekyll_orig_build_dependency_paths environment, context
        end


        def __jekyll_wrap_init_with environment, coder
          __jekyll_orig_init_with environment, coder
          @jekyll_assets = Set.new coder["jekyll_assets"].map{ |p|
            expand_root_path(p)
          }
        end


        def __jekyll_wrap_encode_with coder
          __jekyll_orig_encode_with coder

          coder["jekyll_assets"] = jekyll_assets.map{ |p|
            relativize_root_path p
          }
        end

      end
    end
  end
end


Sprockets::ProcessedAsset.send :include, Jekyll::AssetsPlugin::Patches::ProcessedAssetPatch
