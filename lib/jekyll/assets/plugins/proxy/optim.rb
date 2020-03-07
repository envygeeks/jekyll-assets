# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    module Plugins
      class ImageOptim < Proxy
        content_types %r@^image/(?!x-icon$)[a-zA-Z0-9\-_+]+$@
        arg_keys :optim

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
          optimc = env.asset_config[:plugins][:img][:optim]
          return @file unless optimc

          preset = args[:optim] == true ? :jekyll : args[:optim].to_sym
          raise UnknownPresetError, preset if preset != :jekyll && !optimc.key?(preset)
          optim = ::ImageOptim.new(optimc[preset] || {})
          optim.optimize_image!(@file)
          @file
        end
      end
    end
  end
end

# rubocop:enable Metrics/LineLength
Jekyll::Assets::Hook.register :config, :before_merge do |c|
  c.deep_merge!({
    plugins: {
      img: {
        optim: {
          jekyll: {
            pngout: false,
            allow_lossy: true,
            jpegtran: { progressive: false },
            jpegrecompress: { quality: 2 },
            advpng: false,
            svgo: false,
            jpegoptim: {
              max_quality: 60,
              allow_lossy: true,
              strip: :all,
            },
          },
        },
      },
    },
  })
end
