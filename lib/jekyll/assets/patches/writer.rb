# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    module Patches
      module Writer

        # --
        # Override skip? and add some logging.
        # @return [true, false]
        # --
        def skip?(logger)
          return true if File.exist?(target)
          logger.debug "Writing asset to #{target}"
          false
        end

        # --
        # Adds a hook to #super
        # @note before_hook, after_hook
        # @return [super]
        # --
        def call
          before_hook(asset, env: environment)
          after_hook(out = super,
            env: environment, asset: asset
          )

          out
        end

        # --
        # Runs the before hook
        # @note hook: before_write
        # @return [nil]
        # --
        private
        def before_hook(asset, env:)
          Jekyll::Assets::Hook.trigger :asset, :before_write do |v|
            v.call(asset, env)
          end
        end

        # --
        # Runs the after hook
        # @note hook: after_write
        # @return [nil]
        # --
        private
        def after_hook(out, asset:, env:)
          Jekyll::Assets::Hook.trigger :asset, :after_write do |v|
            v.call(out, asset, env)
          end
        end
      end
    end
  end
end

# --
module Sprockets
  module Exporters
    class FileExporter
      prepend Jekyll::Assets::Patches::Writer
    end
  end
end
