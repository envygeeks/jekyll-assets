# stdlib
require "ostruct"


module Jekyll
  module AssetsPlugin
    class Configuration
      DEFAULTS = {
        :dirname        => "assets",
        :sources        => %w{_assets/javascripts _assets/stylesheets _assets/images},
        :js_compressor  => nil,
        :css_compressor => nil,
        :cachebust      => :hard,
        :cache          => false,
        :gzip           => %w{ text/css application/javascript }
      }.freeze


      def initialize config = {}
        @data = OpenStruct.new DEFAULTS.merge(config)

        @data.sources  = [ @data.sources ] if @data.sources.is_a? String
        @data.dirname  = @data.dirname.gsub(/^\/+|\/+$/, "")

        compress = OpenStruct.new @data.compress

        @data.js_compressor   ||= compress.js
        @data.css_compressor  ||= compress.css
        @data.cache           ||= @data.cache_assets

        # if baseurl not given - autoguess base on dirname
        @data.baseurl ||= "/#{@data.dirname}/".squeeze '/'
      end


      def baseurl
        @data.baseurl.chomp "/"
      end


      def js_compressor
        compressor @data.js_compressor
      end


      def css_compressor
        compressor @data.css_compressor
      end


      def cachebust
        none?(@data.cachebust) ? :none : @data.cachebust.to_sym
      end


      def cache_assets?
        !!@data.cache
      end


      def cache_path
        @data.cache.is_a?(String) ? @data.cache : ".jekyll-assets-cache"
      end


      def gzip
        return @data.gzip if @data.gzip.is_a? Array
        @data.gzip ? DEFAULTS[:gzip] : []
      end


      def method_missing name, *args, &block
        @data.send name, *args, &block
      end


      protected


      def none? val
        val.nil? || val.empty? || "none" == val.to_s.downcase
      end


      def compressor val
        none?(val) ? nil : val.to_sym
      end
    end
  end
end
