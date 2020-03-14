# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

module Jekyll
  module Assets
    class Extensible
      attr_reader :args
      attr_reader :asset
      attr_reader :ctx

      #
      # Create a new instance
      # @param asset [Sprockets::Asset] the asset
      # @param args [Args] the parsed Liquid tag args
      # @param ctx the current context
      # @since 3.0.0
      #
      def initialize(asset:, args:, ctx:)
        @args = args
        @asset = asset
        @ctx = ctx
      end

      #
      # The current Sprockets environment
      # @return [Env]
      # @since 4.0.0
      #
      def env
        site = @ctx.registers[:site]
        site&.sprockets
      end

      #
      # The current Jekyll instance
      # @return [Jekyll::Site]
      # @since 4.0.0
      #
      def jekyll
        return unless env
        env&.jekyll
      end

      class << self

        #
        # Track the classes that inherit your class
        # @note you should be using this when using extensible.
        # @param [<Any>] kls the class.
        # @return [Array<Class>]
        # @since 3.0.0
        #
        def inherited(klass = nil)
          return @inherited ||= [] if klass.nil?
          @inherited ||= []
          @inherited.push(
            klass
          )
        end

        #
        # Track the requirements of a given plugin
        # @note the searcher should use this to determine viability
        # @return [Hash<Symbol,Object>]
        # @since 3.0.0
        #
        def requirements
          @requirements ||= {
            internal: false,
            args: [],
            types: [
              #
            ]
          }
        end

        #
        # Mark a plugin as internal
        # @return [true]
        # @since 3.0.0
        #
        def internal!
          if name.start_with?("Jekyll::Assets")
            requirements[:internal] = true
          end
        end

        #
        # Is this plugin internal?
        # @return [true, false]
        # @since 3.0.0
        #
        def internal?
          !!requirements[
            :internal
          ]
        end

        #
        # Determine if a class matches the reqs
        # @param [String, Symbol] type the current content type.
        # @param [Hash] args the parsed liquid args.
        # @return [true, false]
        # @since 3.0.0
        #
        def for?(type:, args:)
          for_type?(type) && for_args?(
            args
          )
        end

        #
        # Determine if a reqs args are met
        # @param args [Hash] the parsed liquid args
        # @return [true, false]
        # @since 3.0.0
        #
        def for_args?(args)
          return true if arg_keys.empty?
          arg_keys.collect { |k| args.key?(k) }.none? do |k|
            k == false
          end
        end

        #
        # Determine if a reqs content type is met
        # @param type [String, Symbol] the current content type
        # @return [true, false]
        # @since 3.0.0
        #
        def for_type?(type)
          return true if content_types.empty?
          content_types.any? do |k|
            k.is_a?(Regexp) ? type =~ k : k.to_s == type.to_s
          end
        end

        #
        # Add or get content types for a plugin
        # @note these content types are requirements
        # @return [Array]
        # @since 4.0.0
        #
        def content_types(*types)
          return requirements[:types] if types.empty?
          requirements[:types].concat(
            types
          )
        end

        #
        # Add or get arg keys for a plugin
        # @note these keys are key requirements
        # @return [Array]
        # @since 4.0.0
        #
        def arg_keys(*keys)
          return requirements[:args] if keys.empty?
          requirements[:args].concat(
            keys
          )
        end
      end
    end
  end
end
