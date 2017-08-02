# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Env < Sprockets::Environment
      attr_accessor :jekyll
      attr_reader :cache_path

      class << self

        # --
        # A list of instances for Jekyll and their paths.
        # This works around Jekyll watch and build booting twice.
        # @return [Hash]
        # --
        def instances
          return @instances ||= {
            #
          }
        end

        # --
        # A list of Liquid Proxies.
        # @return [Set]
        # --
        def liquid_proxies
          Liquid::Tag::Proxies
        end

        # --
        # XXX: Remove this in 3.0, it's unecessary.
        # Initialize a new instance of ourselves onto Jekyll if not exist.
        # @param [Jekyll::Site] jekyll the site instance.
        # --
        def init(jekyll, key = jekyll.in_source_dir)
          Jekyll.logger.debug "Creating a new instance of: ", self
          Jekyll.logger.debug "The old value of Sprockets: ",
            jekyll.sprockets

          instances[key] = new(
            jekyll
          )

          jekyll.sprockets.excludes.map(&jekyll.config["exclude"].method(:<<))
          jekyll.config["exclude"].uniq!
        end
      end

      # --
      # XXX: Remove in 3.0
      # Used is deprecated, use Manifest#add.
      # @return [Manifest]
      # --
      def used
        Logger.deprecate "Env#used is deprecated use Manifest#add", jekyll do
          manifest
        end
      end

      # --
      # Disables GZIP.  You should be using your server to do this and even
      # if you don't, there are far better and more efficient algorithms out
      # right now that are in beta.  Try Googling Googles new compression.
      # --
      def skip_gzip?
        true
      end

      # --
      # Builds a list of excludes for Jekyll.
      # @return [Set]
      # --
      def excludes
        excludes = Set.new
        excludes << strip_path(in_cache_dir)
        excludes
      end

      # --
      # Returns all the assets.
      # --
      def all_unparsed_assets
        @unparsed_assets ||= logical_paths.select do |(_, val)|
          val.start_with?(jekyll.in_source_dir)
        end
      end

      # --
      # Converts this class into a set of Drops.
      # @return [Hash]
      # --
      def to_liquid_payload
        jekyll.sprockets.all_unparsed_assets.each_with_object({}) do |(key, val), hash|
          hash[key] = Jekyll::Assets::Liquid::Drop.new(
            val, jekyll
          )
        end
      end

      # --
      # Initialize a new instance of this class.
      # @param [<Anything>] path This is passed upstream, we don't care.
      # @param [Jekyll::Site] jekyll the Jekyll instances.
      # XXX: Merge with .init in 3.0
      # --
      def initialize(path, jekyll = nil)
        (jekyll = path; path = nil) if path.is_a?(Jekyll::Site)

        @used = Set.new
        path ? super(path) : super()
        @jekyll = jekyll

        # TODO: In Jekyll-Assets 3 this should be fixed up to be a method.
        @cache_path = asset_config.fetch("cache", ".asset-cache") || ".asset-cache"
        if File.exist?(cache_path_in_source_dir = jekyll.in_source_dir(@cache_path))
          @cache_path = cache_path_in_source_dir
        end

        # XXX: In 3.0, we need to drop anything to do with instance eval,
        #   and imply pass the instance, this will make our code cleaner.

        Hook.trigger :env, :init do |hook|
          hook.arity > 0 || 0 > hook.arity ? hook.call(self) : instance_eval(
            &hook
          )
        end

        # Make sure that we add extras.
        extra_assets.each do |asset|
          manifest.add(
            asset
          )
        end
      end

      # --
      # A list of Liquid Proxies.
      # @return [Set]
      # --
      def liquid_proxies
        self.class.liquid_proxies
      end

      # --
      # Make a path land inside of our cache directory.
      # @param [<Anything>] *paths the paths you wish to land.
      # @return [Pathname/Pathutil]
      # --
      def in_cache_dir(*paths)
        paths.reduce(cache_path) do |base, path|
          Jekyll.sanitized_path(base, path)
        end
      end

      # --
      # Deprecated: Use Manifest#to_compile
      # XXX: Remove in 3.0
      # --
      def all_assets
        Logger.deprecate "Env#all_assets is deprecated, use Manifest#all", jekyll do
          manifest.all
        end
      end

      # --
      # Assets you tell us you want to always compile, even if you do not
      # use them.  Just like Rails this is probably normally used.
      # --
      def extra_assets
        assets = asset_config["assets"] ||= []
        each_logical_path(*assets).map do |v|
          manifest.find(v).first
        end
      end

      # --
      # Whether or not we need a CDN.
      # --
      def cdn?
        !dev? && asset_config.key?("cdn") && \
          asset_config["cdn"]
      end

      # --
      # The BaseURL mixed with Jekyll's own BaseURL.
      # rubocop:disable Style/ExtraSpacing
      # --
      def baseurl
        ary = []

        ary << jekyll.config["baseurl"] unless cdn? && asset_config["skip_baseurl_with_cdn"]
        ary <<  asset_config[ "prefix"] unless cdn? && asset_config[ "skip_prefix_with_cdn"]

        File.join(*ary.delete_if do |val|
          val.nil? || val.empty?
        end)
      end

      # --
      # Whether or not we are in development mode.
      # rubocop:enable Style/ExtraSpacing
      # --
      def dev?
        %W(development test).include?(Jekyll.env)
      end

      # --
      # Whether or not we should compress assets.
      # --
      def compress?(what)
        !!asset_config["compress"].fetch(
          what, false
        )
      end

      # --
      # The asset configuration.
      # --
      def asset_config
        jekyll.config["assets"] ||= {}
      end

      # --
      # Whether or not we are digesting.
      # @return [true,false]
      # --
      def digest?
        !!asset_config[
          "digest"
        ]
      end

      # --
      # Prefix path prefixes the path with the baseurl and the cdn if it
      # exists and is in the right mode to use it.  Otherwise it will only use
      # the baseurl and asset prefix.  All of these can be adjusted...
      # @param [String,Pathname,Pathutil] path the path to prefix.
      # @return [Pathname,Pathutil,String]
      # --
      def prefix_path(path = nil)
        cdn = asset_config["cdn"]
        base_url = baseurl

        path_ = []
        path_ << base_url unless base_url.empty?
        path_ << path unless path.nil?

        url = cdn && cdn?? File.join(cdn, *path_) : File.join(*path_)
        url.chomp("/")
      end


      # --
      # Sprockets cached instance.
      # @return [Cached]
      # --
      def cached
        return @cached ||= Cached.new(
          self
        )
      end

      # --
      # The manifest we use to pull assets.
      # @return [Manifest]
      # --
      def manifest
        return @manifest ||= Manifest.new(self, jekyll.in_dest_dir(
          asset_config["prefix"]
        ))
      end

      # --
      # Write assets with the manifest if they aren't proxied assets.  If
      # they are then we go on to write them ourselves.  We don't necessarily
      # integrate with the manifest that deeply because it's hard.
      # --
      def write_all
        assets = manifest.all.to_a.compact
        if assets.size != manifest.all.size
          begin
            Jekyll.logger.error "", "Asset inconsistency, expected " +
              "#{manifest.all.size}, can only write #{
                assets.size
              }"
          rescue
            # When a serious error happens in the upstream manifest.
            Jekyll.logger.error "", "Asset inconsistency, unable to " \
              "determine the problem, please clear your cache."
          end
        end

        assets = manifest.all.group_by do |v|
          v.is_a?(
            Liquid::Tag::ProxiedAsset
          )
        end

        # These are assets that aren't proxied, they returned fals when
        # they were asked if they belonged to a proxy.

        if assets.key?(false)
          manifest.compile(assets[false].map(
            &:logical_path
          ))
        end

        # Proxied assets will not compile the normal way since they are
        # always considered uniq when used, and they supply their own inline
        # caching, so we always write them individually since they will
        # never actually show up inside of the manifest.

        if assets.key?(true)
          unless assets[true].empty?
            Pathutil.new(in_cache_dir)
              .mkdir_p
          end

          assets[true].map do |asset|
            asset.write_to(jekyll.in_dest_dir(File.join(asset_config["prefix"],
              digest?? asset.digest_path : asset.logical_path
            )))
          end
        end
      end

      # --
      # Undocumented
      # --
      private
      def strip_path(path)
        path.sub(jekyll.in_source_dir("/"),
          ""
        )
      end
    end
  end
end
