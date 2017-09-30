# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Liquid
      class Tag
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
            constants.select { |o| const_get(o).for?(tag) }.each do |v|
              const_get(v).defaults
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
            constants.select { |o| const_get(o).for?(tag) }.each do |v|
              const_get(v).new(args, **kwd).run
            end
          end
        end

        # --
        # Provides a base class for any defaults you have, this
        # way you don't have to do everything just to get some defaults
        # for your stuff.
        # --
        class Default
          def self.inherited(kls)
            defaults(kls)
            for_(kls)
          end

          # --
          # @param [Object] kls the class to patch.
          # Creates a singleton that allows us to check if
          # the current default supports the current Liquid tag
          # that we are working with.
          # @return [nil]
          # --
          def for_(kls)
            unless kls.respond_to?(:for)
              kls.define_singleton_method :for? do |t|
                defined?(kls::FOR) && kls::FOR.include?(t)
              end
            end
          end

          # --
          # @param [Object] kls the class to patch.
          # defaults crates a singleton that ships you static
          # hash of defaults.  Where defaults (the static kind) are
          # things that get merged in early.
          # @return [nil]
          # --
          def defaults(kls)
            unless kls.respond_to?(:defaults)
              kls.define_singleton_method :defaults do
                return {}
              end
            end
          end

          # --
          # run is a method that is used when non-static
          # defaults are needed.  You don't need to supply
          # this method if you do not need this type of
          # default for your application.
          # @return [nil]
          # --
          def run
            jekyll.logger.debug "#{self.class.name} has no dynamic defaults" \
              " skipping."
          end

          # --
          def initialize(args, asset:, jekyll:, env:)
            @asset = asset
            @jekyll = jekyll
            @args = args
            @env = env
          end
        end
      end
    end
  end
end
