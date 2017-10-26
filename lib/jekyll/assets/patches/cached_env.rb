# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
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
        # Conditionally creates the find_asset! method from
        # Sprockets 4.x so that we don't have to change all that
        # much to get things compatible between the two.
        # --
        unless Sprockets::CachedEnvironment.method_defined?(:find_asset!)

          # --
          # Copyright 2017 Sprockets.
          # @url https://github.com/rails/sprockets
          # @license MIT
          # --
          def find_asset!(*args)
            uri, = resolve!(*args)
            if uri
              load(uri)
            end
          end

          # --
          # rubocop:disable Style/ClassAndModuleChildren
          # Patches it onto the base class too.
          # If it's not on cached, it's not on Env.
          # So we need to add it there.
          # --
          class Sprockets::Base
            def find_asset!(*args)
              cached.send(__method__, *args)
            end
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
