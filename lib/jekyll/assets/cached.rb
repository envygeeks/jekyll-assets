# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Cached < Sprockets::CachedEnvironment
      attr_reader :jekyll, :parent
      def initialize(env)
        @parent = env
        @jekyll = env.jekyll
        super env
      end
    end
  end
end
