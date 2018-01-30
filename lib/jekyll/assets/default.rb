# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require_relative "extensible"
require "active_support/hash_with_indifferent_access"
require "active_support/core_ext/hash/indifferent_access"
require "active_support/core_ext/hash/deep_merge"

module Jekyll
  module Assets
    class Default < Extensible
      # --
      # @param [String] type the content type.
      # @param [Hash] args the args from the liquid tag.
      # Get all of the static defaults.
      # @return [Hash]
      # --
      def self.get(type:, args:)
        rtn = Default.inherited.select do |o|
          o.for?({
            type: type,
            args: args,
          })
        end

        ida = HashWithIndifferentAccess.new
        rtn.sort { |v| v.internal? ? 1 : - 1 }.each_with_object(ida) do |v, h|
          h.deep_merge!(v.static)
        end
      end

      # --
      # Set non-static defaults around the asset.
      # @param [Hash] args the arguments to work on.
      # @param [String] type the content type to work with.
      # @param [Sprockets::Asset] asset the asset.
      # @param [Env] env the environment.
      # @return nil
      # --
      def self.set(args, asset:, ctx:)
        set_static(args, asset: asset)
        rtn = Default.inherited.select do |o|
          o.for?(type: asset.content_type, args: args)
        end

        rtn.each do |o|
          o.new({
            args: args,
            asset: asset,
            ctx: ctx,
          }).run
        end
      end

      # --
      def self.set_static(args, asset:)
        get(type: asset.content_type, args: args).each do |k, v|
          k = k.to_sym

          unless args.key?(k)
            args[k] = args[k].is_a?(Hash) ?
              args[k].deep_merge(v) : v
          end
        end
      end

      # --
      # @param [Hash] hash the defaults.
      # @note this is used from your inherited class.
      # Allows you to set static defaults for your defaults.
      # @return nil
      # --
      def self.static(hash = nil)
        return @static ||= {}.with_indifferent_access if hash.nil?
        static.deep_merge!(hash)
      end

      # --
      # Search for set_* methods and run those setters.
      # @note this shouldn't be used directly by end-users.
      # @return nile
      # --
      def run
        methods = self.class.instance_methods - Object.instance_methods
        methods.grep(%r!^set_!).each do |v|
          send(v)
        end
      end

      # --
      def config
        @config ||= @env.asset_config[:defaults][self.class
          .name.split("::").last.downcase]
      end
    end
  end
end
