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
    # ##### bundles
    #
    # Array of filenames or filename patterns that needs to be generated for the
    # generated site. You can use `*` and `**` wildcards in filename patterns:
    #
    #     'foobar.jpg'  will match 'foobar.jpg' only
    #     '*.jpg'       will match 'foo.jpg', but not 'foo/bar.jpg'
    #     '**.jpg'      will match 'foo.jpg', 'foo/bar.jpg', etc.
    #
    # Default: ['app.css', 'app.js', '**.jpg', '**.png', '**.gif']
    #
    #
    # ##### compress
    #
    # Sets compressors for the specific types of file: `js`, or `css`.
    #
    # Possible variants:
    #
    #     css  => 'yui', 'sass', nil
    #     js   => 'yui', 'unglifier', nil
    #
    # Default: { 'css' => nil, 'js' => nil } (no compression at all)
    #
    #
    # ##### dirname
    #
    # Pathname of the destination of generated (bundled) assets relative to the
    # destination of the root.
    #
    # Default: 'assets'
    #
    class Configuration < OpenStruct
      @@defaults = {
        :dirname  => 'assets',
        :sources  => %w{_assets/javascripts _assets/stylesheets _assets/images},
        :bundles  => %w{app.css app.js **.jpg **.png **.gif},
        :compress => { :css => nil, :js => nil }
      }

      def initialize config = {}
        super @@defaults.merge(config)

        self.sources  = [ self.sources ] if self.sources.is_a? String
        self.bundles  = [ self.bundles ] if self.bundles.is_a? String

        self.compress = OpenStruct.new(self.compress)
      end

      # Returns bundles array with pattern strings converted to RegExps
      #
      #   'foobar.jpg'    => 'foobar.jpg'
      #   '*.png'         => /[^\]+\.png/
      #   '**.gif'        => /.+?\.gif/
      #
      def bundle_filenames
        bundles.map do |pattern|
          if pattern =~ /^\*/
            pattern = pattern.dup

            pattern.gsub!(/\./, '\\.')
            pattern.sub!(/\*{2}/, '.+?')
            pattern.sub!(/\*{1}/, '[^/]+')

            pattern = /^#{pattern}$/
          end

          pattern
        end
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
