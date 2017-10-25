# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License

module Jekyll
  module Assets
    module Utils
      module_function

      # --
      # param [String] the content type
      # Strips the secondary content from type.
      # @return [String]
      # --
      def strip_secondary_content_type(str)
        str = str.split("/")
        raise ArgumentError, "#{str.join("/")} is invalid." if str.size > 2
        File.join(str[0], str[1].rpartition(/\+/).last)
      end

      # --
      # @param [String] path the path.
      # Strip the start and end slashes in a path.
      # @return [String]
      # --
      def strip_slashes(path)
        return if path.nil? || path == ""
        path.gsub(/^\/|\/$/, "")
      end

      # --
      # @param [String] url the url.
      # Make a url a proper url, and an https url.
      # @return [String]
      # --
      def make_https(url)
        return if url.nil? || url == ""
        url.gsub(%r!(https?:)?//!,
          "https://")
      end
    end
  end
end
