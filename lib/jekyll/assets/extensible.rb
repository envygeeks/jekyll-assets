# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Extensible
      attr_reader :args
      attr_reader :jekyll
      attr_reader :asset
      attr_reader :env

      # --
      def initialize(asset:, args:, env:)
        @args = args
        @jekyll = env.jekyll
        @asset = asset
        @env = env
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
      # @note a type is a "content type"
      # Allows you to use types to determine if this class fits.
      # @param [String] type the content type.
      # @param [Hash] args the arguments.
      # @return [true, false]
      # --
      def self.for?(type:, args:)
        self.types.any? do |k|
          k.is_a?(Regexp) ? !!(type =~ k) : k.to_s == type.to_s
        end
      end

      # --
      # Attach your class a type.
      # @param [Array<String>] types the content types.
      # @note a type is a content type.
      # @return [nil]
      # --
      def self.types(*types)
        types.empty?? @types ||= [] :
          @types = types
      end
    end
  end
end
