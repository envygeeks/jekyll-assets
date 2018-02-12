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
          Hook.trigger :asset, :after_compression do |h|
            h.call(input, out, "application/javascript")
          end
          out
        end
      end

      # rubocop:disable Metrics/LineLength
      Sprockets.register_compressor "application/javascript", :assets_uglify, Uglify
      Hook.register :env, :after_init, priority: 3 do |e|
        e.js_compressor = nil
        next unless e.asset_config[:compression]
        if Utils.javascript?
          e.js_compressor = :assets_uglify
        end
      end
    end
  end
end
