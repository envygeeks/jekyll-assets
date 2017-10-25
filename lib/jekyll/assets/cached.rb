# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

require "sprockets/cached_environment"
require "forwardable/extended"

module Jekyll
  module Assets
    class Cached < Sprockets::CachedEnvironment
      extend Forwardable::Extended
      attr_reader :uncached

      rb_delegate :manifest, to: :@uncached
      rb_delegate :asset_config, to: :@uncached
      rb_delegate :jekyll, to: :@uncached

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
