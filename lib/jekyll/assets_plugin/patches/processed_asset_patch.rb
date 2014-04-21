# stdlib
require "set"

# 3rd-party
require "sprockets"

module Jekyll
  module AssetsPlugin
    module Patches
      module ProcessedAssetPatch
        def self.included(base)
          base.class_eval do
            attr_reader :jekyll_assets

            alias_method :__orig_build_dependency_paths,
              :build_dependency_paths

            alias_method :build_dependency_paths,
              :__wrap_build_dependency_paths

            alias_method :__orig_init_with, :init_with
            alias_method :init_with, :__wrap_init_with

            alias_method :__orig_encode_with, :encode_with
            alias_method :encode_with, :__wrap_encode_with
          end
        end

        def __wrap_build_dependency_paths(environment, context)
          @jekyll_assets = Set.new

          context.jekyll_assets.each do |path|
            @jekyll_assets << path
            environment.find_asset(path)
              .jekyll_assets.each { |p| @jekyll_assets << p }
          end

          __orig_build_dependency_paths environment, context
        end

        def __wrap_init_with(environment, coder)
          __orig_init_with environment, coder

          @jekyll_assets = Set.new coder["jekyll_assets"]
            .map { |p| expand_root_path(p) }
        end

        def __wrap_encode_with(coder)
          __orig_encode_with coder

          coder["jekyll_assets"] = jekyll_assets.map do |path|
            relativize_root_path path
          end
        end

        ::Sprockets::ProcessedAsset.send :include, self
      end
    end
  end
end
