# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require_relative "../utils"

module Jekyll
  module Assets
    module Patches
      # --
      # Patches `Sprockets::CachedEnvironment` with some of
      # the stuff that we would like available.  Including our
      # `Util` methods, the `#manifest`, the `#asset_config`,
      # and even `#jekyll`, so that we can remain fast while
      # having some of the stuff that we need access to.
      # --
      module CachedEnv
        include Utils

        # --
        attr_reader :manifest
        attr_reader :asset_config
        attr_reader :jekyll

        # --
        # @param [Env] env the environment.
        # Patches initialize so we can give access to `#jekyll`.
        # @return [self]
        # --
        def initialize(env)
          super

          @manifest = env.manifest
          @asset_config = env.asset_config
          @jekyll = env.jekyll
        end

        # --
        def find_asset(*)
          super.tap do |v|
            v&.environment = self
          end
        end

        # --
        def find_asset!(*a)
          load(resolve!(*a).first).tap do |v|
            v.environment = self
          end
        end
      end
    end
  end
end

# --
module Sprockets
  class CachedEnvironment
    prepend Jekyll::Assets::Patches::CachedEnv
  end
end
