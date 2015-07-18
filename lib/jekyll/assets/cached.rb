module Jekyll
  module Assets
    class Cached < Sprockets::CachedEnvironment
      attr_reader :jekyll, :parent

      def initialize(env)
        @parent, @jekyll = \
          env, env.jekyll
        super env
      end
    end
  end
end
