# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Extensible
      attr_reader :ctx
      attr_reader :args
      attr_reader :jekyll
      attr_reader :asset
      attr_reader :env

      # --
      def initialize(asset:, args:, ctx:)
        @args = args
        @env = ctx.registers[:site].sprockets
        @jekyll = @env.jekyll
        @asset = asset
        @ctx = ctx
      end

      # --
      # Allows us to keep track of inheritence.
      # @note you should be using this when using extensible.
      # @param [<Any>] kls the class.
      # @return [Array<Class>]
      # --
      def self.inherited(kls = nil)
        @inherited ||= []
        return @inherited if kls.nil?
        @inherited << kls
      end

      # --
      def self.requirements
        @requirements ||= {
          internal: false,
          args: [], types: [
            #
          ]
        }
      end

      # --
      def self.internal!
        if name.start_with?("Jekyll::Assets")
          requirements[:internal] = true
        end
      end

      # --
      def self.internal?
        requirements[
          :internal
        ]
      end

      # --
      # @note a type is a "content type"
      # Allows you to use types to determine if this class fits.
      # @param [String] type the content type.
      # @param [Hash] args the arguments.
      # @return [true, false]
      # --
      def self.for?(type:, args:)
        for_type?(type) && for_args?(args)
      end

      # --
      def self.for_args?(args)
        return true if arg_keys.empty?
        arg_keys.collect { |k| args.key?(k) }.none? do |k|
          k == false
        end
      end

      # --
      def self.for_type?(type)
        return true if content_types.empty?
        content_types.any? do |k|
          k.is_a?(Regexp) ? type =~ k : k.to_s == type.to_s
        end
      end

      # --
      # Creates `#arg_keys`, and `#content_types` so that you
      #   can limit your surface for an extensible plugin.  For
      #   example if you only work for
      # --
      m = [%i(content_types types), %i(arg_keys args)]
      m.each do |(k, v)|
        instance_eval <<-RUBY
          def self.#{k}(*a)
            requirements[:#{v}].concat(a)
          end
        RUBY
      end
    end
  end
end
