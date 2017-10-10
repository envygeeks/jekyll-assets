# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Env < Sprockets::Environment

      extend Forwardable::Extended
      rb_delegate :dev?, to: :Jekyll, bool: true
      rb_delegate :logger, to: :"Jekyll::Assets::Logger"
      rb_delegate :digest, to: :asset_config, type: :hash, bool: true
      rb_delegate :cache_path, to: :"asset_config[:caching]", type: :hash, key: :path, wrap: :in_source_dir
      rb_delegate :cache?, to: :"asset_config[:cache]", type: :hash, key: :enabled
      rb_delegate :production?, to: :jekyll
      rb_delegate :safe?, to: :jekyll
      attr_accessor :jekyll

      # --
      # @param [Jekyll::Site] jekyll the Jekyll instances.
      # @param [<Anything>] path This is passed upstream, we don't care.
      # initialize creates a new instance of this class.
      # @return [Env] the environment.
      # --
      def initialize(jekyll = nil)
        super()

        @jekyll = jekyll
        jekyll.sprockets = self
        @cache = nil

        logger
        manifest
        enable_compression!
        disable_erb!
        asset_config
        sources!
        cache

        precompile!
        Hook.trigger :env, :init do |hook|
          instance_eval(&hook)
        end
      end

      # --
      # @note this is a runner.
      # sources sets up the users sources.
      # @return [Array<>]
      # --
      def sources!
        @sources ||= begin
          asset_config["sources"].each do |v|
            unless paths.include?(jekyll.in_source_dir(v))
              append_path jekyll.in_source_dir(v)
            end
          end

          paths
        end
      end

      # --
      # cache sets up the cache for the user.
      # @return [Sprockets::Cache]
      # --
      def cache
        @cache ||= begin
          cache, type = asset_config[:caching].values_at(:enabled, :type)
          out = Sprockets::Cache::MemoryStore.new if cache && type == "memory"
          out = Sprockets::Cache::FileStore.new(cache_path) if cache && type == "file"
          out = Sprockets::Cache::NullStore.new if !cache
          Sprockets::Cache.new(out, Logger)
        end
      end

      # --
      # asset_config returns the users configuration.
      # @note from the `assets` key in `_config.yml` of Jekyll.
      # @return [Hash] the configuration.
      # --
      def asset_config
        @asset_config ||= begin
          user = jekyll.config["assets"] ||= {}
          Config.new(user)
        end
      end

      # --
      # @note this is mostly used for caching.
      # manifest returns a manifest for you to quickly find assets.
      # @return [Sprockets::Manifest]
      def manifest
        @manifest ||= begin
          Sprockets::Manifest.new(self, in_dest_dir)
        end
      end

      # --
      # skip_gzip? tells Sprockets to skip Gzipping files.
      # @note this might not work in Sprockets 4.x it needs testing.
      # @return [TrueClass] skip it.
      # --
      def skip_gzip?
        true
      end

      # --
      # @note this is used in a Jekyll hook.
      # excludes builds a list of excludes we ship to Jekyll.
      # @return [Set]
      # --
      def excludes
        excludes = Set.new
        excludes << strip_path(in_cache_dir)
        excludes
      end

      # --
      # @see Liquid::Drop for more information.
      # to_liquid_payload converts this your assets `Drop`s
      # @return [Hash]
      # --
      def to_liquid_payload
        require "jekyll/assets/drop"

        each_file.each_with_object({}) do |k, h|
          path = strip_path(k)
          h.update({
            path => Drop.new(path, {
              jekyll: jekyll
            })
          })
        end
      end

      # --
      # in_cache_dir makes a path land inside the cache.
      # @param [<String>] *paths the paths you wish to land.
      # @return [Pathutil]
      # --
      def in_cache_dir(*paths)
        paths.reduce(cache_path.to_path) do |b, p|
          Jekyll.sanitized_path(b, p)
        end
      end

      # --
      # @param [<String>] *paths the paths you wish to land.
      # in_dest_dir makes a path to land inside of the write path
      # @return [Pathutil]
      # --
      def in_dest_dir(*paths)
        jekyll.in_dest_dir(prefix_path, *paths)
      end

      # --
      # @note this is only used internally.
      # cdn? tells us whether we should be using a or not.
      # @return [true, false]
      # --
      def cdn?
        !dev? && asset_config[:cdn].key?(:url) &&
              asset_config[:cdn][:url]
      end

      # --
      # rubocop:disable Style/ExtraSpacing
      # baseurl mixes the prefix, and other stuff.
      # @return [String]
      # --
      def baseurl
        @baseurl ||= begin
          ary = []
          s1, s2 = asset_config[:cdn].values_at(:baseurl, :prefix)
          ary << jekyll.config["baseurl"] unless cdn? && !s1
          ary <<  asset_config[:prefix  ] unless cdn? && !s2
          File.join(*ary.delete_if do |val|
            val.nil? || val.empty?
          end)
        end
      end

      # --
      # @param [String] what what you want to compress.
      # compress? allows us to determine if we should compress.
      # @return [true, false]
      def compress?(what)
        !!asset_config[:compress][what]
      end

      # --
      # prefix_path prefixes the path with the baseurl.
      # @param [String,Pathname,Pathutil] path the path to prefix.
      # @return [Pathname,Pathutil,String]
      # --
      def prefix_path(path = nil)
        path_ = []

        path_ << baseurl unless baseurl.empty?
        unless path.nil?
          path_ << path
        end

        url = asset_config[:cdn][:url] && cdn??
          File.join(asset_config[:cdn][:url], *path_) :
          File.join(*path_)

        url.chomp("/")
      end

      # --
      # @note we only shim stuff.
      # cached is an instance of `Cached` for Sprockets.
      # @return [Cached]
      # --
      def cached
        @cached ||= Cached.new(self)
      end

      # --
      # @param [String] path the path.
      # strip_path strips the path of the Jekyll source dir.
      # @return [String]
      # --
      private
      def strip_path(path)
        path.sub(jekyll.in_source_dir("/"), "")
      end

      # --
      # @param [String] path the path.
      # in_source_dir wraps around Jekyll's `#in_source_dir`
      # @return [Pathutil]
      # --
      def in_source_dir(path)
        Pathutil.new(jekyll.in_source_dir(path))
      end

      # --
      # @note this is a runner.
      # enable_compression! enables compression if the user requests it.
      # @return [nil]
      private
      def enable_compression!
        opts = asset_config[:plugins][:compression]

        if opts[:css][:enabled]
          @css_compressor = :sass
        end

        if opts[:js][:enabled]
          try_require "uglifier" do
            @js_compressor = !jekyll.safe ? Uglifier.new(
              opts[:js][:opts]) : :uglify
          end
        end

        nil
      end

      # --
      # precompile! finds and compiles requested unused assets.
      # @note you can set this with `precompile` in `_config.yml`.
      # @return [nil]
      # --
      private
      def precompile!
        assets = asset_config[:precompile]
        assets = assets.map do |v|
          manifest.compile(v)
        end

        nil
      end

      # --
      # disable_erb! disables erb if you are in safe mode.
      # @note this is necessary to keep security for Github.
      # @return [nil]
      # --
      private
      def disable_erb!
        if jekyll.safe
          @config = hash_reassoc @config, :registered_transformers do |o|
            o.delete_if do |v|
              v.proc == Sprockets::ERBProcessor
            end
          end
        end
      end
    end
  end
end
