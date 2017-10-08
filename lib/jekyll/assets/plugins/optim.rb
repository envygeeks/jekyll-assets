# Frozen-string-literal: true
# Copyright: 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Plugins
      class ImageOptimProxy < Proxy
        type %r!^image\/[a-zA-Z]+$!
        args_key :optim

        # --
        class MultiplePredefinedPresetsSpecified < RuntimeError
          def initialize
            super "Specifying multiple pre-defined presets at " \
              "the same time is not supported"
          end
        end

        # --
        class PresetAlreadySpecified < RuntimeError
          def initialize
            super "Specifying pre-defined preset and preset-by-name " \
              "at the same time is not supported"
          end
        end

        # --
        class UnknownPreset < RuntimeError
          def initialize(name)
            super "Unknown image_optim preset `#{name}'"
          end
        end

        # --
        # @todo right now this is working on the image
        #  directly... rather than copying the data to a temporary
        #  file and then doing it's work on said copy, this isn't
        #  very friendly to users.
        # --
        def process
          asset_config = @asset.env.asset_config
          image_optim_config = asset_config["image_optim"]
          presets = (@opts.keys - ARGS.map(&:to_sym))


          raise PresetAlreadySpecified if @opts.key?(:preset) && presets.any?
          if presets.count > 1
            raise MultiplePredefinedPresetsSpecified
          end

          name = @opts[:preset]
          name = presets.first.to_s unless name || !presets.any?
          if name != "default" && !image_optim_config.key?(name)
            raise UnknownPreset, name
          end

          config = image_optim_config[name]
          image_optim = ::ImageOptim.new(config)
          image_optim.optimize_image!(@asset.filename)
          # ^ Problem spot, this should not do that.
        end
      end
    end
  end
end
