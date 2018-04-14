# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Utils
      def self.old_sprockets?
        @old_sprockets ||= begin
          Gem::Version.new(Sprockets::VERSION) < Gem::Version.new("4.0.beta")
        end
      end

      # --
      def self.new_uglifier?
        require "uglifier"
        modern_supported_version = "4.0.0"
        Gem::Version.new(Uglifier::VERSION) >= Gem::Version
          .new(modern_supported_version)
      rescue LoadError
        return true
      end

      # --
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
        asset_config[:raw_precompile].each_with_object([]) do |v, a|
          if v.is_a?(Hash)
            dst, src = in_dest_dir.join(v[:dst]).tap(&:mkdir_p), v[:src]
            glob_paths(src).each do |sv|
              a << {
                src: sv,
                full_dst: dst.join(sv.basename),
                dst: dst,
              }
            end
          else
            glob_paths(v).each do |p|
              next unless p

              dst = strip_paths(p)
              dst = in_dest_dir(dst)
              dst.parent.mkdir_p

              a << {
                src: p,
                full_dst: dst,
                dst: dst,
              }
            end
          end
        end
      end

      # --
      def find_assets_by_glob(glob)
        glob_paths(glob).map do |v|
          find_asset!(v.to_s)
        end
      end

      # --
      def glob_paths(glob)
        out = []

        paths.each do |sv|
          sv = Pathutil.new(sv)

          if sv.directory?
            out.concat(sv.glob(glob).to_a)
          end
        end

        out
      end

      # --
      def url_asset(url, type:)
        name = File.basename(url)

        Url.new(*[Utils.old_sprockets? ? self : nil, {
          name: name,
          filename: url,
          content_type: type,
          load_path: File.dirname(url),
          id: Digest::SHA256.hexdigest(url),
          logical_path: name,
          metadata: {},
          source: "",
          uri: url,
        }].compact)
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
        args[:argv1] !~ %r!^(?\!(https?:)?//)!
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
            o[k] = parse_liquid(o[k], {
              ctx: ctx,
            })
          end
        when obj.is_a?(Array)
          obj.map do |v|
            parse_liquid(v, {
              ctx: ctx,
            })
          end
        when obj.is_a?(String)
          ctx.registers[:site].liquid_renderer.file("(asset:var)")
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
      # @return [String]
      # --
      def in_cache_dir(*paths)
        path = Pathutil.pwd.join(strip_slashes(asset_config[:caching][:path]))
        Pathutil.new(paths.reduce(path.to_s) do |b, p|
          Jekyll.sanitized_path(b, p)
        end)
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
        Pathutil.new(jekyll
          .in_dest_dir(*paths))
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
        dest = strip_slashes(asset_config[:destination])
        cdn = make_https(strip_slashes(asset_config[:cdn][:url]))
        base = strip_slashes(jekyll.config["baseurl"])
        cfg = asset_config

        path = []
        path << cdn  if Jekyll.production? && cdn
        path << base if Jekyll.dev? || !cdn || (cdn && cfg[:cdn][:baseurl])
        path << dest if Jekyll.dev? || !cdn || (cdn && cfg[:cdn][:destination])
        path << user_path unless user_path.nil? || user_path == ""

        path = File.join(path.flatten.compact)
        return path if cdn && Jekyll.production?
        "/" + path
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
        File.join(str[0], str[1].rpartition(%r!\+!).last)
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
