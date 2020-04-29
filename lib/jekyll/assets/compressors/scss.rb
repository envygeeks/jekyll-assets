# Frozen-string-literal: true
# Copyright: 2017 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    module Compressors
      class Scss < Sprockets::SassCompressor
        def call(input)
          out = super(input)
          Hook.trigger :asset, :after_compression do |h|
            !out.is_a?(Hash) \
              ? out = h.call(input, out, 'text/css')
              : out[:data] = h.call(
                input, out[:data],
                'text/css'
              )
          end

          out
        end
      end

      # --
      Sprockets.register_compressor 'text/css', :assets_scss, Scss
      Hook.register :env, :after_init, priority: 3 do |e|
        next if Utils.activate('sassc')

        e.css_compressor = nil
        next unless e.asset_config[:compression]
        e.css_compressor = :assets_scss
      end
    end
  end
end
