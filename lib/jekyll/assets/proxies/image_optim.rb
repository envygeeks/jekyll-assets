# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2017 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

try_require "image_optim" do
  IMAGE_OPTIM_ARGS = %W(preset).freeze
  IMAGE_OPTIM_PRESETS = %W(@default).freeze

  class JekyllAssetsImageOptim

    class UnknownPresetError < RuntimeError
      def initialize(presetName)
        "Unknown image_optim preset '#{ presetName }'"
      end
    end

    # ------------------------------------------------------------------------

    class PresetAlreadySpecifiedError < RuntimeError
      def initialize
        "Specifying pre-defined preset and preset-by-name at the same time is not supported"
      end
    end

    # ------------------------------------------------------------------------

    class MultiplePredefinedPresetsSpecifiedError < RuntimeError
      def initialize
        "Specifying multiple pre-defined presets at the same time is not supported"
      end
    end

    # ------------------------------------------------------------------------

    def initialize(asset, opts, args)
      @asset = asset
      @opts = opts
      @args = args
    end

    # ------------------------------------------------------------------------

    def process
      asset_config = @asset.env.asset_config || {}
      image_optim_config = asset_config["image_optim"] || {}

      predefinedPresets = (@opts.keys - IMAGE_OPTIM_ARGS.map(&:to_sym))

      raise PresetAlreadySpecifiedError if @opts.key?(:preset) && predefinedPresets.any?
      raise MultiplePredefinedPresetsSpecifiedError if predefinedPresets.count > 1

      presetName = @opts[:preset]
      presetName = predefinedPresets.first.to_s unless presetName || !predefinedPresets.any?

      if presetName != "default" && !image_optim_config.key?(presetName)
        raise UnknownPresetError, presetName
      end
      config = image_optim_config[presetName] || {}

      image_optim = ::ImageOptim.new(config)
      image_optim.optimize_image!(@asset.filename)
    end

  end

  Jekyll::Assets::Env.liquid_proxies.add :image_optim, [:img, :asset_path], *(IMAGE_OPTIM_ARGS + IMAGE_OPTIM_PRESETS) do
    def initialize(asset, opts, args)
      @imageOptim = JekyllAssetsImageOptim.new(asset, opts, args)
    end

    # ------------------------------------------------------------------------

    def process
      @imageOptim.process
    end

  end
end
