# stdlib
require 'ostruct'


module Jekyll
  module AssetsPlugin
    # Plugin configuration class.
    #
    #
    # ##### sources
    #
    # Pathnames where to find assets relative to the root of the site.
    #
    # Default: ['_assets/javascripts', '_assets/stylesheets', '_assets/images']
    #
    #
    # ##### compress
    #
    # Sets compressors for the specific types of file: `js`, or `css`.
    #
    # Possible variants:
    #
    #     css  => 'yui', 'sass', nil
    #     js   => 'yui', 'uglifier', nil
    #
    # Default: { 'css' => nil, 'js' => nil } (no compression at all)
    #
    #
    # ##### dirname
    #
    # Destination pathname of processed assets relative to the compiled site
    # root (which is `_site` by default).
    #
    # Default: 'assets'
    #
    #
    # ##### baseurl
    #
    # Base URL for assets paths. By default equals dirname surrunded with
    # slashes. You ight want to change it if your blog has baseurl configuration
    # and served not from the root of the server, or if you want to keep your
    # assets on CDN.
    #
    class Configuration
      DEFAULTS = {
        :dirname  => 'assets',
        :sources  => %w{_assets/javascripts _assets/stylesheets _assets/images},
        :compress => { :css => nil, :js => nil }
      }.freeze

      def initialize config = {}
        @data = OpenStruct.new DEFAULTS.merge(config)

        @data.sources  = [ @data.sources ] if @data.sources.is_a? String
        @data.compress = OpenStruct.new @data.compress
        @data.dirname  = @data.dirname.gsub(/^\/+|\/+$/, '')

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
