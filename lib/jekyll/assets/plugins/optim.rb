# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require "jekyll/assets"
try_require "image_optim" do
  module Jekyll
    module Assets
      module Plugins
        class ImageOptim < Proxy
          args_key :optim
          types "image/webp", "image/jpeg", "image/jpeg", "image/tiff",
            "image/bmp", "image/gif", "image/png",
            "image/svg+xml"

          class UnknownPresetError < RuntimeError
            def initialize(name)
              "Unknown image_optim preset `#{name}'"
            end
          end

          class MultiplePredefinedPresetsSpecified < RuntimeError
            def initialize
              super "Specifying multiple pre-defined presets " \
                "at the same time is not supported"
            end
          end

          def process
            optimc = @env.asset_config[:plugins][:img][:optim]
            preset = @args[:optim].keys
            if preset.count > 1
              raise MultiplePredefinedPresetsSpecified
            end

            preset = preset.first
            raise UnknownPreset, preset if preset != :default && !optimc.key?(preset)
            oc = optimc[preset] unless preset == :default
            optim = ::ImageOptim.new(oc || {})
            optim.optimize_image!(@file)
            @file
          end
        end
      end
    end
  end

  Jekyll::Assets::Hook.register :config, :pre do |c|
    c.deep_merge!({
      plugins: {
        img: {
          optim: {
            #
          }
        }
      }
    })
  end
end
