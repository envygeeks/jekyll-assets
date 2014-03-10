module Jekyll
  module AssetsPlugin
    class AssetPath
      attr_writer :anchor, :query

      def initialize(asset)
        asset.bundle!
        @asset = asset
      end

      def cachebust
        @cachebust ||= @asset.site.assets_config.cachebust
      end

      def path
        :hard == cachebust && @asset.digest_path || @asset.logical_path
      end

      def query
        query = []

        query << "cb=#{@asset.digest}" if :soft == cachebust
        query << @query               if @query

        "?#{query.join '&'}" unless query.empty?
      end

      def anchor
        "##{@anchor}" if @anchor
      end

      def to_s
        "#{@asset.site.assets_config.baseurl}/#{path}#{query}#{anchor}"
      end
    end
  end
end
