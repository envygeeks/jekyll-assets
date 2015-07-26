module Jekyll
  module Assets

    # Creates:
    #   * `#parent` - Leading back to the original Jekyll::Assets::Env instance.
    #   * `#jekyll` - Leading back to the `Jekyll::Site` instance.
    #
    # The reason we add these is because sometimes we might need access to
    # the configuration or even to find another asset tied to a cached asset
    # so we can verify, find... etc, etc, etc.

    class Cached < Sprockets::CachedEnvironment
      attr_reader :jekyll, :parent
      def initialize(env)
        @parent, @jekyll = env, env.jekyll
        super env
      end
    end
  end
end
