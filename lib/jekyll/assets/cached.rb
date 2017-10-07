# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Cached < Sprockets::CachedEnvironment
      extend Forwardable::Extended
      attr_reader :uncached

      rb_delegate :manifest, to: :uncached
      rb_delegate :asset_config, to: :uncached
      rb_delegate :jekyll, to: :uncached

      # --
      # Initialize a new instance
      # @param [Env] env the environment
      # @return [Cached]
      # --
      def initialize(env)
        super

        # --
        # Normally you shouldn't be using uncached to do
        #   something, but we provide it so that we can get
        #   access to things like `asset_config`, `manifest`,
        #   and `Jekyll` itself. Though `manifest` is used
        #   via the `find_asset` anyways.
        # --
        @uncached = env
      end
    end
  end
end
