# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Author: Jordon Bedwell
# Encoding: utf-8

module Jekyll
  module Assets
    class Cache
      extend Forwardable::Extended
      rb_delegate :get, to: :@cache
      rb_delegate :fetch, to: :@cache
      rb_delegate :clear, to: :@cache
      rb_delegate :set, to: :@cache
      Upstream = Sprockets::Cache

      # --
      # @inherit StanardError
      # Error for when the cache dir is not absolute.
      # @return [nil]
      # --
      class RelativeCacheDir < StandardError
        def initialize
          super "Cache dir must be absolute"
        end
      end

      # --
      # Initialize a new instance
      # @return [self]
      # --
      def initialize(dir:, manifest:, config:)
        @manifest = manifest
        @dir = validate_and_make_cache(dir)
        @config = config
        create
      end

      # --
      # Whether or not caching is enabled
      # @note configure with caching.enabled
      # @return [true, false]
      # --
      def enabled?
        @config[:caching][:enabled]
      end

      # --
      # The type of caching.
      # @note configure with caching.type
      # @return [String]
      # --
      def type
        @config[:caching][:type]
      end

      # --
      # Return the class for the type.
      # @note configure with caching.type
      # @return [String]
      # --
      def upstream
        return Upstream::NullStore unless enabled?
        return Upstream::MemoryStore if type == "memory"
        Upstream::FileStore
      end

      # --
      # Create the cache.
      # @note configure with cache
      # @return [Upstream]
      # --
      private
      def create
        @cache ||= begin
          out = Upstream.new(upstream, Logger)
          @manifest.new_manifest? \
            ? out.tap(&:clear)
            : out
        end
      end

      # --
      # Make the dir, and validate it
      # @raise bad dir if it's not absolute
      # @return [Pathutil]
      # --
      def validate_and_make_cache(dir)
        dir = Pathutil.new(dir)
        raise RelativeCacheDir unless dir.absolute?
        dir.tap(&:mkdir_p)
      end
    end
  end
end
