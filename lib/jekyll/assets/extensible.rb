# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Extensible
      def initialize(asset:, args:, env:)
        @args = args
        @jekyll = env.jekyll
        @asset = asset
        @env = env
      end

      def self.inherited(kls = nil)
        @inherited ||= []
        return @inherited if kls.nil?
        @inherited << kls
      end

      def self.for?(type:, args:)
        self.types.any? do |k|
          k.is_a?(Regexp) ? !!(type =~ k) :
            k.to_s == type.to_s
        end
      end

      def self.types(*types)
        types.empty?? @types ||= [] :
          @types = types
      end
    end
  end
end
