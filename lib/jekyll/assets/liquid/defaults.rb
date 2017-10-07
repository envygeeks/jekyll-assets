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

        # --
        # @param tag [String] the tag you are working with.
        # @param jekyll [Jekyll::Site] the Jekyll instance (w/ Sprockets).
        # get_defaults will return defaults that aren't dynamic.
        # @return [HashWithInifferentAccess]
        # --
        module_function
        def get_defaults(tag)
          out = HashWithIndifferentAccess.new
          Default.inherited.select { |o| o.for?(tag) }.
          each_with_object(out) do |v, h|
            h.deep_merge!(v.defaults)
          end
        end

        # --
        # @param args [Hash] the current arguments hash.
        # @param jekyll [Jekyll::Site] the Jekyll instance (w/ Sprockets.)
        # @param tag [String] the tag you are working with.
        # set_defaults sets all your dynamic defaults.
        # @return [HashWithIndifferentAcces]
        # --
        module_function
        def set_defaults(tag, args:, **kwd)
          Default.inherited.select { |o| o.for?(tag) }.each do |o|
            o.new(args, **kwd).run
          end
        end
      end

      # --
      # @abstract you are meant to inherit this class.
      # Provides a base class for any defaults you have.
      # @note MyDefaults < Default
      # @return [nil]
      # --
      class Default
        def self.inherited(kls = nil)
          return @inherited ||= [] if kls.nil?
          (@inherited ||= []) \
            << kls
        end

        # --
        # @param [Array<String,Symbol>] tags the tags.
        # defaults_for allows you to set the name of the tags to work on.
        # @return [nil]
        # --
        def self.tags(*tags)
          return @tags ||= [] if tags.empty?

          @tags ||= []
          tags = tags.map(&:to_sym)
          @tags  |= tags
        end

        # --
        # @param [Hash] hash the defaults.
        # defaults allows you to set the static defaults.
        # @return [Hash]
        # --
        def self.defaults(hash = nil)
          return @defaults || {} if hash.nil?
          hash = HashWithIndifferentAccess.new(hash)
          @defaults = hash
        end

        # --
        # @param [String,Symbol] tag the tag.
        # for? allows us to check and see if this supports a tag.
        # @return [true, false]
        # --
        def self.for?(tag)
          tags.include?(tag.to_sym)
        end

        # --
        # @note override at your own risk.
        # run is a method that to run your set_* methods.
        # @return [nil]
        # --
        def run
          methods = (self.class.instance_methods - Object.instance_methods)
          methods.grep(/^set_/).each do |v|
            send(v)
          end
        end

        # --
        def initialize(args, asset:, env:)
          @asset = asset
          @jekyll = env.jekyll
          @args = args
          @env = env
        end
      end
    end
  end
end
