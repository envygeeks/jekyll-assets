# stdlib
require "ostruct"


module Jekyll
  module AssetsPlugin
    class Configuration
      DEFAULTS = {
        :dirname      => "assets",
        :sources      => %w{_assets/javascripts _assets/stylesheets _assets/images},
        :compress     => { :css => nil, :js => nil },
        :cachebust    => :hard,
        :cache_assets => false,
        :gzip         => %w{ text/css application/javascript },
        :turbolinks   => false
      }.freeze


      def initialize config = {}
        @data = OpenStruct.new DEFAULTS.merge(config)

        @data.sources  = [ @data.sources ] if @data.sources.is_a? String
        @data.compress = OpenStruct.new @data.compress
        @data.dirname  = @data.dirname.gsub(/^\/+|\/+$/, "")

        # if baseurl not given - autoguess base on dirname
        @data.baseurl ||= "/#{@data.dirname}/".squeeze '/'
      end


      def baseurl
        @data.baseurl.chomp "/"
      end


      def js_compressor
        compressor @data.compress.js
      end


      def css_compressor
        compressor @data.compress.css
      end


      def cachebust
        none?(@data.cachebust) ? :none : @data.cachebust.to_sym
      end


      def cache_assets?
        !!@data.cache_assets
      end

      def turbolinks?
        !!@data.turbolinks
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
