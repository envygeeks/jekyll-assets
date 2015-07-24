module Jekyll
  module Assets

    # Takes over Sprockets cached so that we can add the parent and
    # `Jekyll` just incase you need them... we need both at times to do certain
    # tasks such as checking things without having to do long work arounds.

    class Cached < Sprockets::CachedEnvironment
      attr_reader :jekyll, :parent

      def initialize(env)
        @parent, @jekyll = env, env.jekyll
        super env
      end
    end
  end
end
