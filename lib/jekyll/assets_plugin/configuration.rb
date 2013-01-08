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
    class Configuration < OpenStruct
      @@defaults = {
        :dirname  => 'assets',
        :sources  => %w{_assets/javascripts _assets/stylesheets _assets/images},
        :compress => { :css => nil, :js => nil }
      }

      def initialize config = {}
        super @@defaults.merge(config)

        self.sources  = [ self.sources ] if self.sources.is_a? String
        self.compress = OpenStruct.new(self.compress)
        self.dirname  = self.dirname.gsub(/^\/+|\/+$/, '')

        # if baseurl not given - autoguess base on dirname
        self.baseurl ||= "/#{self.dirname}/".squeeze '/'
      end

      def js_compressor
        return compress.js.to_sym if compress.js
        false
      end

      def css_compressor
        return compress.css.to_sym if compress.css
        false
      end
    end
  end
end
