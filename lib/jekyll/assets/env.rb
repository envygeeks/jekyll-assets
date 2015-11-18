# Frozen-string-literal: true
# Copyright: 2012-2015 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Env < Sprockets::Environment
      attr_reader :jekyll, :used

      class << self
        attr_accessor :past
        def liquid_proxies
          return Liquid::Tag::Proxies
        end
      end

      #

      def all_unparsed_assets
        @unparsed_assets ||= logical_paths.select do |(_, val)|
          val.start_with?(jekyll.in_source_dir)
        end
      end

      #

      def to_liquid_payload
        jekyll.sprockets.all_unparsed_assets.inject({}) do |hsh, (key, val)|
          hsh[key] = Jekyll::Assets::Liquid::Drop.new(val, jekyll)
        hsh
        end
      end

      #

      def initialize(path, jekyll = nil)
        jekyll, path = path, nil if path.is_a?(Jekyll::Site)
        @used, @jekyll = Set.new, jekyll

        path ? super(path) : super()
        Hook.trigger :env, :init do |hook|
          hook.arity > 0 || 0 > hook.arity ? hook.call(self) : \
            instance_eval(&hook)
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

      # Merged form of `#extra_assets`

      def all_assets
        Set.new(@used).merge extra_assets
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
        path_ = _baseurl
        cdn = asset_config["cdn"]
        path_ << path unless path.nil? || path.empty?
        cdn? && cdn ? File.join(cdn, *path_).chomp("/") : \
          File.join(*path_).chomp("/")
      end

      #

      def cached
        Cached.new(self)
      end

      #

      def write_all
        past = self.class.past ||= Set.new
        (@used.any?? all_assets : past).each do |obj|
          if past.add(obj) && path = as_path(obj)
            obj.write_to path
          end
        end
      end

      #

      private
      def _baseurl
        rtn = []
        rtn << baseurl unless cdn? && asset_config["skip_baseurl_with_cdn"]
        rtn <<  prefix unless cdn? && asset_config[ "skip_prefix_with_cdn"]
        rtn.delete_if { |val| val.nil? || val.empty? }
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
