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
        next unless e.asset_config[:compression]

        e.js_compressor = nil unless Utils.javascript?
        config = e.asset_config[:compressors][:uglifier].symbolize_keys
        e.js_compressor = Uglify.new(config) if Utils.javascript?
      end
    end
  end
end
