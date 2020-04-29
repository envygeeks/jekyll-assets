# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    class Cache
      extend Forwardable
      def_delegator :instance, :get
      def_delegator :instance, :fetch
      def_delegator :instance, :clear
      def_delegator :instance, :set
      Upstream = Sprockets::Cache

      #
      # @inherit StandardError
      # Error for when the cache dir is not absolute.
      # @return [nil]
      #
      class RelativeCacheDir < StandardError
        def initialize
          super 'Cache dir must be absolute'
        end
      end

      #
      # Initialize a new instance
      # @return [self]
      #
      def initialize(dir:, manifest:, config:)
        @manifest = manifest
        @dir = validate_and_make_cache(dir)
        @config = config
      end

      #
      # Whether or not caching is enabled
      # @note configure with caching.enabled
      # @return [true, false]
      #
      def enabled?
        @config[:caching][
          :enabled
        ]
      end

      #
      # The type of caching.
      # @note configure with caching.type
      # @return [String]
      #
      def type
        @config[:caching][
          :type
        ]
      end

      #
      # Return the class for the type.
      # @note configure with caching.type
      # @return [
      #   <Upstream::FileStore>,
      #   <Upstream::MemoryStore>,
      #   <Upstream::NullStore>,
      # ]
      #
      def upstream
        return Upstream::NullStore unless enabled?
        return Upstream::MemoryStore.new(4096) if type == 'memory'
        Upstream::FileStore.new(@dir)
      end

      #
      # Create the cache.
      # @note configure with cache
      # @return [Upstream]
      #
      def instance
        return @instance if defined?(@instance)
        @instance = begin
          out = Upstream.new(upstream, Logger)
          @manifest.new_manifest? \
            ? out.tap(&:clear)
            : out
        end
      end

      #
      # Make the dir, and validate it
      # @raise bad dir if it's not absolute
      # @return [Pathutil]
      #
      def validate_and_make_cache(dir)
        dir = Pathutil.new(dir)
        raise RelativeCacheDir unless dir.absolute?
        dir.tap(&:mkdir_p)
      end
    end
  end
end
