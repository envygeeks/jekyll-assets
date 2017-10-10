# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "active_support/hash_with_indifferent_access"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/hash/deep_merge"

module Jekyll
  module Assets
    module Liquid
      module Defaults

        module_function
        def get(type:, args:)
          rtn = Default.inherited.select do |o|
            o.for?({
              type: type,
              args: args,
            })
          end

          ida = HashWithIndifferentAccess.new
          rtn.each_with_object(ida) do |v, h|
            h.deep_merge!(v.static)
          end
        end

        module_function
        def set(args, type:, asset:, env:)
          rtn = get({
            type: type,
            args: args,
          })

          args.deep_merge!(rtn)
          rtn = Default.inherited.select do |o|
            o.for?({
              type: type,
              args: args,
            })
          end

          rtn.each do |o|
            o.new(args, {
              asset: asset,
                env: env,
            }).run
          end
        end
      end

      class Default < Extensible
        def self.static(hash = nil)
          return @static ||= {} if hash.nil?
          @static = hash.with_indifferent_access
        end

        def run
          methods = self.class.instance_methods
          methods = methods - Object.instance_methods
          methods.grep(/^set_/).each do |v|
            send(v)
          end
        end

        def initialize(args, asset:, env:)
          @args = args
          @jekyll = env.jekyll
          @asset = asset
          @env = env
        end
      end
    end
  end
end
