# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Cached < Sprockets::CachedEnvironment
      attr_reader :jekyll, :parent

      # --
      # @param [Env] env the environment
      # Initialize a new instance
      # --
      def initialize(env)
        @parent = env
        @jekyll = env.jekyll
        @resolve_cache = {}
        super env
      end


      # --
      # Resolve an asset.
      # --
      def resolve(*args)
        @resolve_cache[args] ||= super
      end
    end
  end
end
