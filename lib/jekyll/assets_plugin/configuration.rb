# stdlib
require "ostruct"


module Jekyll
  module AssetsPlugin
    class Configuration
      DEFAULTS = {
        :dirname  => "assets",
        :sources  => %w{_assets/javascripts _assets/stylesheets _assets/images},
        :compress => { :css => nil, :js => nil }
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
        @data.compress.js ? @data.compress.js.to_sym : false
      end


      def css_compressor
        @data.compress.css ? @data.compress.css.to_sym : false
      end


      def method_missing name, *args, &block
        @data.send name, *args, &block
      end
    end
  end
end
