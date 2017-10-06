# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Env < Sprockets::Environment

      extend Forwardable::Extended
      rb_delegate :logger, to: :Logger
      rb_delegate :dev?, to: :Jekyll, bool: true
      rb_delegate :digest, to: :asset_config, type: :hash, bool: true
      rb_delegate :cache?, to: :"asset_config[:cache]", type: :hash, key: :enabled
      rb_delegate :cache_path, to: :"asset_config[:cache]", type: :hash, key: :path, wrap: :in_source_dir
      rb_delegate :production?, to: :jekyll
      rb_delegate :safe?, to: :jekyll
      attr_accessor :jekyll

      # --
      # @param [Jekyll::Site] jekyll the Jekyll instances.
      # @param [<Anything>] path This is passed upstream, we don't care.
      # initialize creates a new instance of this class.
      # --
      def initialize(jekyll = nil)
        super()

        jekyll.sprockets = self
        @jekyll = jekyll

        logger
        manifest
        asset_config
        sources
        cache

        Hook.trigger :env, :init do |hook|
          hook.arity > 0 || 0 > hook.arity ? hook.call(self) :
            instance_eval(&hook)
        end
      end

      # --
      # sources sets up the users sources on the instance.
      # @note this is a runner.
      # --
      def sources
        @sources ||= begin
          asset_config["sources"].each do |v|
            append_path jekyll.in_source_dir(v)
          end

          paths
        end
      end

      # --
      # cache sets up the cache for the user.
      # @note this is a runner.
      # --
      def cache
        @cache ||= begin
          cache, type = asset_config[:cache].values_at(:enabled, :type)
          out = Sprockets::Cache::MemoryStore.new if cache && type == "memory"
          out = Sprockets::Cache::FileStore.new(cache_path) if cache && type == "file"
          out = Sprockets::Cache::NullStore.new if !cache
        out
        end
      end

      # --
      # @return [Hash] the configuration.
      # asset_config gives you access to the assets
      # configuration on Jekyll's own configuration instance.
      # it also wraps around, merges defaults and sets
      # everything up for your usage.
      # --
      def asset_config
        @asset_config ||= begin
          user = jekyll.config["assets"] ||= {}
          Config.new(user)
        end
      end

      # --
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
      # excludes builds a list of excludes for Jekyll.
      # @return [Set]
      # --
      def excludes
        excludes = Set.new
        excludes << strip_path(in_cache_dir)
        excludes
      end

      # --
      # to_liquid_payload converts this class into `Drop`s,
      # so that users have access to all of the assets they wish
      # to use, this should be quick and painless.
      # @return [Hash]
      # --
      def to_liquid_payload
        require "jekyll/assets/liquid/drop"

        each_file.each_with_object({}) do |k, h|
          path = strip_path(k)
          h.update({
            path => Liquid::Drop.new(path, {
              jekyll: jekyll
            })
          })
        end
      end

      # --
      # in_cache_dir makes a path to land inside the cache.
      # @param [<Anything>] *paths the paths you wish to land.
      # @return [Pathutil]
      # --
      def in_cache_dir(*paths)
        paths.reduce(cache_path.to_path) do |b, p|
          Jekyll.sanitized_path(b, p)
        end
      end

      # --
      # in_dest_dir makes a path to land inside of the write
      # path, this is to say where we will write to in the `_site`
      # directory (or whatever you set `_site` to.)
      # --
      def in_dest_dir(*paths)
        jekyll.in_dest_dir(prefix_path, *paths)
      end

      # --
      # extra_assets finds and compiles the assets you wish
      # to always compile,regardless of usage.  This is the slowest
      # part of Jekyll Assets tbh, because it takes time to
      # do this if you have a lot of them.
      # @return [nil]
      # --
      def extra_assets
        assets = asset_config[:precompile]
        assets = assets.map do |v|
          manifest.compile(v)
        end

        nil
      end

      # --
      # cdn? tells us whether we should be using a or not.
      # @return [true, false]
      # --
      def cdn?
        !dev? && asset_config[:cdn].key?(:url) &&
              asset_config[:cdn][:url]
      end

      # --
      # rubocop:disable Style/ExtraSpacing
      # baseurl mixes our baseurl with Jekyll's baseurl to
      # build out the baseurl to place the assets in, when we
      # are writing our own assets.
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
      # compress? allows us to determine if we should compress
      # a particular asset, such as JavaScript, or SCSS, or even
      # CSS and the like, it's out of our control.
      # @return [true, false]
      def compress?(what)
        !!asset_config[:compress][what]
      end

      # --
      # @param [String,Pathname,Pathutil] path the path to prefix.
      # prefix_path prefixes the path with the baseurl and
      # the cdn if it exists and is in the right mode to use
      # it.  Otherwise itArray will only use the baseurl and`
      # asset prefix.  All of these can be adjusted...
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
      # cached is an instance of `Cached` for Sprockets.
      # what exactly it does, I actually don't know but I do
      # know we modify it to our own Cached so that we can
      # access some stuff in this class.
      # @return [Cached]
      # --
      def cached
        @cached ||= Cached.new(self)
      end

      # --
      # @param [String] path the path.
      # strip_path strips the path of the Jekyll source dir.
      # This is useful if you wish to use a relative path to search
      # for something... rather than the full path.
      # @return [String]
      # --
      private
      def strip_path(path)
        path.sub(jekyll.in_source_dir("/"), "")
      end

      # --
      # @param [String] path the path.
      # in_source_dir wraps around Jekyll's `#in_source_dir`
      # so that we can create a Pathutil, with all the wrapper
      # options we want on a file.
      # @return [Pathutil]
      # --
      private
      def in_source_dir(path)
        Pathutil.new(jekyll.in_source_dir(path))
      end
    end
  end
end
