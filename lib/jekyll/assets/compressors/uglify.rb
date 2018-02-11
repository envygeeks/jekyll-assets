# Frozen-string-literal: true
# Copyright: 2017 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    module Compressors
      class Uglify < Sprockets::UglifierCompressor
        def call(input)
          out = super(input)
          Hook.trigger(:asset, :after_compression) do |h|
            h.call(input, out, {
              type: :css,
            })
          end
        end
      end

      # --
      Sprockets.register_compressor "text/javascript", \
        :jekyll_assets_uglify, Uglify
    end
  end
end
