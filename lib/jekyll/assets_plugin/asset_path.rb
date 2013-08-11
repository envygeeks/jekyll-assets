module Jekyll
  module AssetsPlugin
    class AssetPath

      attr_reader :asset


      def initialize site, pathname, *args
        pathname, _, @anchor = pathname.rpartition "#" if pathname["#"]
        pathname, _, @query  = pathname.rpartition "?" if pathname["?"]

        @asset  = site.assets[pathname, *args]
        @site   = site

        site.bundle_asset! asset
      end


      def cachebust
        @cachebust ||= @site.assets_config.cachebust
      end


      def path
        :hard == cachebust && asset.digest_path || asset.logical_path
      end


      def query
        query = []

        query << "cb=#{asset.digest}" if :soft == cachebust
        query << @query               if @query

        "?#{query.join '&'}" unless query.empty?
      end


      def anchor
        "##{@anchor}" if @anchor
      end


      def to_s
        "#{@site.assets_config.baseurl}/#{path}#{query}#{anchor}"
      end

    end
  end
end
