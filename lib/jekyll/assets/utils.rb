# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

module Jekyll
  module Assets
    module Utils
      def self.activate(gem)
        spec = Gem::Specification
        return unless spec.find_all_by_name(gem)&.any? || \
            spec.find_by_path(gem)&.any?

        require gem
        if block_given?
          yield
        end

        true
      end

      # --
      def self.html_fragment(*a)
        Nokogiri::HTML.fragment(*a) do |c|
          c.options = Nokogiri::XML::ParseOptions::NONET | \
            Nokogiri::XML::ParseOptions::NOENT
        end
      end

      # --
      def self.html(*a)
        Nokogiri::HTML.parse(*a) do |c|
          c.options = Nokogiri::XML::ParseOptions::NONET | \
            Nokogiri::XML::ParseOptions::NOENT
        end
      end

      # --
      def self.xml(*a)
        Nokogiri::XML.parse(*a) do |c|
          c.options = Nokogiri::XML::ParseOptions::NONET
        end
      end

      # --
      def raw_precompiles
        asset_config[:raw_precompile].each_with_object([]) do |h, a|
          h = { source: h } unless h.is_a?(Hash)
          r = Regexp.new(h[:strip]) if h.key?(:strip)
          s = h.fetch(:source) { h.fetch(:src) }

          root_glob(s).each do |p|
            d = r.nil? ? p : p.gsub(r, '')
            a.push({
              destination: d.relative,
              full_destination: in_dest_dir(d),
              source: p
            })
          end
        end
      end

      def root_paths
        paths.map(
          &File.method(
            :dirname
          )
        ).uniq
      end

      def all_paths
        paths | root_paths
      end

      # --
      def find_assets_by_glob(glob)
        glob_paths(glob).map do |v|
          find_asset!(v.to_s)
        end
      end

      def root_glob(glob)
        Pathutil.new(root).glob(glob).map do |path|
          path.relative_path_from(
            root
          )
        end
      end

      # --
      def glob_paths(glob, all: false)
        out = []

        (all ? all_paths : paths).each do |p|
          p = Pathutil.new(p)
          if p.directory?
            out.concat(
              p.glob(glob).to_a
            )
          end
        end

        out
      end

      # --
      def url_asset(url, type:)
        name = File.basename(url)

        Url.new(
          *[
            nil, {
              name: name,
              filename: url,
              content_type: type,
              load_path: File.dirname(url),
              id: Digest::SHA256.hexdigest(url),
              logical_path: name,
              metadata: {},
              source: "",
              uri: url,
            }
          ].compact
        )
      end

      # --
      # @param [String] url
      # @return [Sprockets::Asset]
      # Wraps around an external url and so it can be wrapped into
      #  the rest of Jekyll-Assets with little trouble.
      # --
      def external_asset(url, args:)
        if args[:asset]&.key?(:type)
          url_asset(url, {
            type: args[:asset][:type],
          })

        else
          _, type = Sprockets.match_path_extname(url, Sprockets.mime_exts)
          logger.debug "no type for #{url}, assuming image/*" unless type
          url_asset(url, {
            type: type || "image/jpeg",
          })
        end
      end

      # --
      # @param [String,Sprockets::Asset] url
      # Tells you if a url... or asset is external.
      # @return [nil,true,false]
      # --
      def external?(args)
        return true  if args.is_a?(Url)
        return false if args.is_a?(Sprockets::Asset)
        return args =~ %r!^(https?:)?//! if args.is_a?(String)
        return args[:external] if args.key?(:external)
        args[:argv1] !~ %r@^(?!(https?:)?//)@
      end

      # --
      # @param [String,Hash<>,Array<>] obj the liquid to parse.
      # Parses the Liquid that's being passed, with Jekyll's context.
      # rubocop:disable Lint/LiteralAsCondition
      # @return [String]
      # --
      def parse_liquid(obj, ctx:)
        case true
        when obj.is_a?(Hash) || obj.is_a?(Liquid::Tag::Parser)
          obj.each_key.with_object(obj) do |k, o|
            o[k] = parse_liquid(o[k],
              ctx: ctx,
            )
          end
        when obj.is_a?(Array)
          obj.map do |v|
            parse_liquid(v, ctx: ctx)
          end
        when obj.is_a?(String)
          k = Digest::SHA256.hexdigest(obj)[0, 6]
          ctx.registers[:site].liquid_renderer.file("(asset:var:#{k})")
            .parse(obj).render!(ctx)
        else
          obj
        end
      end

      # --
      # @param [String] path the path to strip.
      # Strips most source paths from the given path path.
      # rubocop:enable Lint/LiteralAsCondition
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
      # @return [Pathutil]
      # --
      def in_cache_dir(*paths)
        path = Pathutil.pwd.join(strip_slashes(asset_config[:caching][:path]))
        Pathutil.new(paths.reduce(path.to_s) do |b, p|
          Jekyll.sanitized_path(
            b, p
          )
        end)
      end

      # --
      # @note this is configurable with `:destination`
      # Lands your path inside of the destination directory.
      # @param [Array<String>] paths the paths.
      # @return [Pathutil]
      # --
      def in_dest_dir(*paths)
        destination = strip_slashes(asset_config[:destination])

        paths.unshift(destination)
        paths = paths.flatten.compact
        Pathutil.new(jekyll.in_dest_dir(
          *paths
        ))
      end

      # --
      # @param [String] the path.
      # @note this should only be used for *urls*
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      # rubocop:disable Metrics/AbcSize
      # Builds a url path for HTML.
      # @return [String]
      # --
      def prefix_url(user_path = nil)
        cfg, j_cfg = asset_config, jekyll.config
        cdn_url = make_https(strip_slashes(cfg[:cdn][:url]))
        base_url = jekyll.config.fetch("baseurl_root", j_cfg["baseurl"])
        destination = strip_slashes(cfg[:destination])
        base_url = strip_slashes(base_url)
        url = Addressable::URI.new

        if cfg[:full_url]
          url.host = j_cfg["host"]
          url.port = j_cfg["port"]
          url.scheme = "http"
        end

        if cdn_url
          c_url = Addressable::URI.parse(cdn_url)

          if c_url.host
            url.host = c_url.host
            url.scheme = c_url.scheme
            url.port = c_url.port
          else
            host, port = cdn_url.split(":", 1)
            if port && port.to_i != 0
              url.port = port
              url.host = host
            end
          end
        end

        path = []
        path << base_url if base_url?
        path << destination if destination?
        path << user_path unless user_path.nil? || user_path.empty?
        path = path.compact

        path = File.join(path.flatten.compact)
        path = "/" + path unless path.start_with?("/")
        url.path = path
        url.to_s
      end

      def destination?
        c_url = asset_config[:cdn][:url]
        c_cfg = asset_config[:cdn]
        Jekyll.dev? || !c_url || (
          Jekyll.production? && c_url && c_cfg[
            :destination
          ]
        )
      end

      def base_url?
        c_url = asset_config[:cdn][:url]
        c_cfg = asset_config[:cdn]
        Jekyll.dev? || !c_url || (
          Jekyll.production? && c_url && c_cfg[
            :baseurl
          ]
        )
      end

      # --
      # param [String] the content type
      # Strips the secondary content from type.
      # rubocop:enable Metrics/PerceivedComplexity
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/AbcSize
      # @return [String]
      # --
      module_function
      def strip_secondary_content_type(str)
        str = str.split("/")
        raise ArgumentError, "#{str.join('/')} is invalid." if str.size > 2
        File.join(str[0], str[1].split('+').tap(&:shift).join('+'))
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
      # rubocop:disable Metrics/AbcSize
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
      # @yield a blockof code if the require works out.
      # Either require exec.js, and the file or move along.
      # @param [String] file the file to require.
      # @return [nil]
      # --
      def self.javascript?
        activate "execjs" do
          if block_given?
            yield
          end
        end
      rescue ExecJS::RuntimeUnavailable
        false
      end
    end
  end
end
