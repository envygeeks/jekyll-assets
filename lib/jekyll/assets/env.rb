module Jekyll
  module Assets
    class Env < Sprockets::Environment
      attr_reader :jekyll, :used

      class << self
        attr_accessor :assets_cache, :digest_cache
        def digest_cache
          return @digest_cache ||= {}
        end

        #

        def liquid_proxies
          return Liquid::Tag::Proxies
        end
      end

      #

      def inspect
        "<#{self.class.name} compress_js=#{compress?("js")} compress_css=#{compress?("css")} asset_path=#{
          path
        }>"
      end

      #

      def initialize(path, jekyll = nil)
        jekyll, path = path, nil if path.is_a?(Jekyll::Site)
        @used, @jekyll = Set.new, jekyll
        path ? super(path) : super()
        Hook.trigger(:env, :init) do |hook|
          hook.arity > 0 || 0 > hook.arity ? hook.call(self) : instance_eval(&hook)
        end
      end

      #

      def liquid_proxies
        return self.class.liquid_proxies
      end

      # Make sure a path falls withint our cache dir.

      def in_cache_dir(*paths)
        cache_dir = asset_config["cache"] || ".asset-cache"
        jekyll.in_source_dir(cache_dir, *paths)
      end

      # Whether or not we are writing from the cache.

      def cached_write?
        !@used.any?
      end

      # Merged form of `#extra_assets` and `@used` assets.

      def all_assets(cached = false)
        if !cached
          then Set.new(@used).merge extra_assets
          else Set.new(self.class.assets_cache).merge(extra_assets)
        end
      end

      # Assets you tell us you want to always compile, even if you do not
      # use them.  Just like Rails this is probably normally used.

      def extra_assets
        assets = asset_config["assets"] ||= []
        each_logical_path(*assets).map do |v|
          find_asset v
        end
      end

      #

      def cdn?
        !dev? && asset_config.has_key?("cdn") && \
          asset_config["cdn"]
      end

      #

      def baseurl
        jekyll.config["baseurl"]
      end

      #

      def dev?
        %W(development test).include?(Jekyll.env)
      end

      #

      def compress?(what)
        !!asset_config["compress"]. \
          fetch(what, false)
      end

      #

      def asset_config
        jekyll.config["assets"] ||= {}
      end

      #

      def digest?
        !!asset_config["digest"]
      end

      #

      def prefix
        asset_config["prefix"]
      end

      # Prefixes a path with both the #base_url, the prefix and the CDN.

      def prefix_path(path = "")
        prefix  = cdn? && asset_config[ "skip_prefix_with_cdn"] ? nil : self. prefix
        baseurl = cdn? && asset_config["skip_baseurl_with_cdn"] ? nil : self.baseurl
        path    = [baseurl, prefix, path]

        path.delete_if(&:nil?).delete_if(&:empty?)
        cdn = asset_config["cdn"] if asset_config.has_key?("cdn")
        cdn? && cdn ? File.join(cdn, *path).chomp("/") : \
          File.join(*path).chomp("/")
      end

      #

      def cached
        Cached.new(self)
      end

      #

      def write_all
        if cached_write?
          write_cached_assets else write_assets
        end
      end

      #

      private
      def write_assets(assets = self.all_assets)
        self.class.assets_cache = assets
        self.class.digest_cache = Hash[assets.map do |a|
          [a.logical_path, a.digest]
        end]

        assets.each do |v|
          v.write_to as_path v
        end
      end

      #

      private
      def write_cached_assets(assets = all_assets(true))
        assets.each do |a|
          if !a.is_a?(Liquid::Tag::ProxiedAsset)
            viejo = self.class.digest_cache[a.logical_path]
            nuevo = find_asset(a.logical_path).digest
            path  = as_path a

            if nuevo == viejo && File.file?(path)
              next
            end
          else
            if File.file?(a.logical_path)
              next
            end
          end

          self.class.digest_cache[a.logical_path] = a.digest
          a.write_to as_path a
        end
      end

      #

      private
      def as_path(v)
        path = digest?? v.digest_path : v.logical_path
        jekyll.in_dest_dir(File.join(prefix, path))
      end
    end
  end
end
