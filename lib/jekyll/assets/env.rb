# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require_relative "drop"

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

      def initialize(jekyll = nil)
        super()

        @jekyll = jekyll
        jekyll.sprockets = self
        @cache = nil

        logger
        manifest
        asset_config
        enable_compression!
        setup_sources!
        disable_erb!
        cache

        precompile!
        Hook.trigger :env, :init do |hook|
          instance_eval(&hook)
        end
      end

      def skip_gzip?
        true
      end

      def compile(name)
        other = get_name(name)
        asset = find_asset(other)
        didit = manifest.compile(other) if asset
        asset = find_asset!(name) if !didit
        didit = manifest.compile(name) \
          if !didit

        if didit.size > 0
          Hook.trigger :asset, :compile do |h|
            h.call(asset, manifest)
          end
        end
      end

      def cache
        @cache ||= begin
          cache, type = asset_config[:caching].values_at(:enabled, :type)
          out = Sprockets::Cache::MemoryStore.new if cache && type == "memory"
          out = Sprockets::Cache::FileStore.new(cache_path) if cache && type == "file"
          out = Sprockets::Cache::NullStore.new if !cache
          Sprockets::Cache.new(out, Logger)
        end
      end

      def asset_config
        @asset_config ||= begin
          user = jekyll.config["assets"] ||= {}
          Config.new(user)
        end
      end

      def manifest
        @manifest ||= begin
          Sprockets::Manifest.new(self, in_dest_dir)
        end
      end

      def to_liquid_payload
        each_file.each_with_object({}) do |k, h|
          path = strip_paths(k)
          next if File.basename(path).start_with?("_") ||
                  File. dirname(path).start_with?("_")

          h.update({
            path => Drop.new(path, {
              jekyll: jekyll
            })
          })
        end
      end

      def in_cache_dir(*paths)
        paths.reduce(cache_path.to_path) do |b, p|
          Jekyll.sanitized_path(b, p)
        end
      end

      def in_dest_dir(*paths)
        jekyll.in_dest_dir(prefix_path, *paths)
      end

      def cdn?
        !dev? && asset_config[:cdn].key?(:url) &&
              asset_config[:cdn][:url]
      end

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

      def cached
        @cached ||= Cached.new(self)
      end

      def self.register_ext_map(ext, to_ext)
        @ext_maps ||= {}
        @ext_maps.update(
          ext.to_s => to_ext.to_s
        )
      end

      def self.map_ext(ext)
        @ext_maps[ext] || ext
      end

      def get_name(file)
        out = Pathutil.new(strip_paths(file))
        out.sub_ext(self.class.map_ext(
          out.extname)).to_s
      end

      private
      def strip_path(path)
        dir = jekyll.in_source_dir("/")
        path.sub(dir, "")
      end

      private
      def in_source_dir(path)
        dir = jekyll.in_source_dir(path)
        Pathutil.new(dir)
      end

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

      private
      def precompile!
        assets = asset_config[:precompile]
        assets = assets.map do |v|
          compile(v)
        end

        nil
      end

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

      private
      def setup_sources!
        @sources ||= begin
          asset_config["sources"].each do |v|
            unless paths.include?(jekyll.in_source_dir(v))
              append_path jekyll.in_source_dir(v)
            end
          end

          paths
        end
      end

      private
      def strip_paths(path)
        paths.map do |v|
          if path.start_with?(v)
            return path.sub(v + "/", "")
          end
        end

        path
      end

      register_ext_map ".es6", ".js"
      register_ext_map ".coffee", ".js"
      register_ext_map ".js.coffee",".js"
      register_ext_map ".js.coffee.erb", ".js"
      register_ext_map ".coffee.erb", ".js"
      register_ext_map ".es6.erb", ".js"
      register_ext_map ".js.erb", ".js"

      register_ext_map ".sass", ".css"
      register_ext_map ".scss", ".css"
      register_ext_map ".css.scss", ".css"
      register_ext_map ".css.scss.erb", ".css"
      register_ext_map ".css.sass.erb", ".css"
      register_ext_map ".sass.erb", ".css"
      register_ext_map ".css.sass", ".css"
      register_ext_map ".scss.erb", ".css"
      register_ext_map ".css.erb", ".css"
    end
  end
end
