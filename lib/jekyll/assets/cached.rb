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
