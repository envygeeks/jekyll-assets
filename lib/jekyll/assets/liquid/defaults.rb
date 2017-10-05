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
        # Defaults that aren't dynamic can can be quickly
        #   set within the tag parser itself, without the
        #   need of another value.
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
        # @param tag [String] the tag you are working with.
        # @param jekyll [Jekyll::Site] the Jekyll instance (w/ Sprockets.)
        # @param args [Hash] the current arguments hash.
        # Set dynamic defaults.  These are defaults that
        #   might require some value that is set after parsing
        #   is done, like default alts and stuff.
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
      # Provides a base class for any defaults you have, this
      # way you don't have to do everything just to get some defaults
      # for your stuff.
      # --
      class Default
        def self.inherited(kls = nil)
          return @inherited ||= [] if kls.nil?
          (@inherited ||= []) \
            << kls
        end

        # --
        # @param [Array<String,Symbol>] tags the tags.
        # defaults_for allows you to set the tags that
        # you wish to be working with/on when you are ready
        # to set the defaults.
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
        # static_defaults allows you to set (or get) the
        # defauts for the current defaults.  These are static
        # stuff, that can be quickly set.
        # @return [Hash]
        # --
        def self.defaults(hash = nil)
          return @defaults || {} if hash.nil?
          hash = HashWithIndifferentAccess.new(hash)
          @defaults = hash
        end

        # --
        # @param [String,Symbol] tag the tag.
        # for? allows us to check and see if this
        # default will be supporting the current tag and
        # should therefore be ran.
        # @return [true, false]
        # --
        def self.for?(tag)
          tags.include?(tag.to_sym)
        end

        # --
        # run is a method that is used when non-static
        # defaults are needed.  You don't need to supply
        # this method if you do not need this type of
        # default for your application.
        # @return [nil]
        # --
        def run
          @env.logger.debug "#{self.class.name} has no dynamic " \
            "defaults skipping."
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
