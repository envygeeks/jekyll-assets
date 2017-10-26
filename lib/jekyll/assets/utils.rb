# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Utils
      # --
      # @param [String] path the path to strip.
      # Strips most source paths from the given path path.
      # @return [String]
      # --
      def strip_paths(path)
        paths.map do |v|
          if path.start_with?(v)
            return path.sub(v + "/", "")
          end
        end

        path
      end

      # --
      # Lands your path inside of the cache directory.
      # @note configurable with `caching: { path: "dir_name"` }
      # @return [String]
      # --
      def in_cache_dir(*paths)
        destination = strip_slashes(asset_config[:caching][:path])
        path = jekyll.in_source_dir(destination)
        paths.reduce(path) do |b, p|
          Jekyll.sanitized_path(b, p)
        end
      end

      # --
      # @note this is configurable with `:destination`
      # Lands your path inside of the destination directory.
      # @param [Array<String>] paths the paths.
      # @return [String]
      # --
      def in_dest_dir(*paths)
        destination = strip_slashes(asset_config[:destination])

        paths.unshift(destination)
        paths = paths.flatten.compact
        jekyll.in_dest_dir(*paths)
      end

      # --
      # @param [String] the path.
      # @note this should only be used for *urls*
      # Builds a url path for HTML.
      # @return [String]
      # --
      def prefix_url(user_path = nil)
        dest = strip_slashes(asset_config[:destination])
        cdn = make_https(strip_slashes(asset_config[:cdn][:url]))
        base = strip_slashes(jekyll.config["baseurl"])

        path = []
        path << cdn  if Jekyll.production? && cdn
        path << base if Jekyll.dev? || !cdn || (cdn && asset_config[:cdn][:baseurl])
        path << dest if Jekyll.dev? || !cdn || (cdn && asset_config[:cdn][:destination])
        path << user_path unless user_path.nil? || user_path == ""

        path = File.join(path.flatten.compact)
        return path if cdn && Jekyll.production?
        "/" + path
      end

      # --
      # param [String] the content type
      # Strips the secondary content from type.
      # @return [String]
      # --
      module_function
      def strip_secondary_content_type(str)
        str = str.split("/")
        raise ArgumentError, "#{str.join('/')} is invalid." if str.size > 2
        File.join(str[0], str[1].rpartition(/\+/).last)
      end

      # --
      # @param [String] path the path.
      # Strip the start and end slashes in a path.
      # @return [String]
      # --
      module_function
      def strip_slashes(path)
        return if path.nil? || path == ""
        path.gsub(%r!^/|/$!, "")
      end

      # --
      # @param [String] url the url.
      # Make a url a proper url, and an https url.
      # @return [String]
      # --
      module_function
      def make_https(url)
        return if url.nil? || url == ""
        url.gsub(%r!(https?:)?//!,
          "https://")
      end

      # --
      # Get all the manifest files.
      # @note this includes dynamic keys, like SourceMaps.
      # @return [Array<String>]
      # --
      module_function
      def manifest_files(env)
        manifest = env.manifest.data.values_at(*Manifest.keep_keys).map(&:to_a)
        out = manifest.flatten.each_with_object([]) do |v, a|
          path = Pathutil.new(env.in_dest_dir(v))
          a << path.to_s + ".gz" if path.exist? && !env.skip_gzip?
          a << path.to_s if path.exist?
          v = Pathutil.new(v)

          next if v.dirname == "."
          v.dirname.descend.each do |vv|
            vv = env.in_dest_dir(vv)
            unless a.include?(vv)
              a << vv
            end
          end
        end

        out
      end

      # --
      # Either require the file or keep moving along.
      # @yield a block of code if the require works out.
      # @param [String] file the file to require.
      # @return [nil]
      # --
      module_function
      def try_require(file)
        require file
        if block_given?
          yield
        end
      rescue LoadError
        Logger.debug "Unable to load file `#{file}'"
      end

      # --
      # @yield a blockof code if the require works out.
      # Either require exec.js, and the file or move along.
      # @param [String] file the file to require.
      # @return [nil]
      # --
      module_function
      def javascript?
        require "execjs"
        if block_given?
          yield
        end
      rescue ExecJS::RuntimeUnavailable
        nil
      end
    end
  end
end
