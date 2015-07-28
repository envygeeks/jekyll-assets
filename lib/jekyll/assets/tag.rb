module Jekyll
  module Assets

    # TODO: Somewhere in here we need to designate the proxy as an asset
    #   so that the env does not need to be aware of anything.

    class Tag < Liquid::Tag
      require_relative "tag/proxied_asset"
      require_relative "tag/parser"
      attr_reader :args

      class AssetNotFoundError < StandardError
        def initialize(asset)
          super "Could not find the asset `#{asset}'"
        end
      end

      TAGS = {
        "css" => %Q{<link type="text/css" rel="stylesheet" href="%s"%s>},
        "js"  => %Q{<script type="text/javascript" src="%s"%s></script>},
        "img" => %Q{<img src="%s"%s>}
      }

      ALIAS = {
        "image" => "img",
        "stylesheet" => "css",
        "javascript" => "js",
        "style" => "css"
      }

      def initialize(tag, args, tokens)
        @tokens = tokens
        @tag = from_alias(tag)
        @args = Parser.new(args, @tag)
        @og_tag = tag
        super
      end

      # NOTE: We only attach to the regenerator if you are using digested
      #   assets, otherwise we forego any association with it so that we keep
      #   your builds ultra fast, this is ideal in dev.  Disable digests and
      #   let us process independent so the entire site isn't regenerated
      #   because of a single asset change.

      def render(context)
        site = context.registers[:site]
        page = context.registers.fetch(:page, {}).fetch("path", nil)
        sprockets = site.sprockets

        asset = find_asset(sprockets)
        add_as_jekyll_dependency(site, sprockets, page, asset)
        process_tag(sprockets, asset)
      rescue => e
        capture_and_out_error \
          site, e
      end

      private
      def from_alias(tag)
        ALIAS[tag] || \
          tag
      end

      private
      def process_tag(sprockets, asset)
        set_img_alt asset if @tag == "img"
        out = get_path sprockets, asset

        if @tag == "asset_path"
          return out

        elsif @args[:data][:uri]
          return TAGS[@tag] % [
            asset.data_uri, @args.to_html
          ]

        else
          sprockets.used.add(asset)
          return TAGS[@tag] % [
            out, @args.to_html
          ]
        end
      end

      private
      def get_path(sprockets, asset)
        sprockets.prefix_path(
          sprockets.digest?? asset.digest_path : asset.logical_path
        )
      end

      private
      def set_img_alt(asset)
        if !@args[:html]["alt"]
          return @args[:html]["alt"] = asset.logical_path
        end
      end

      private
      def add_as_jekyll_dependency(site, sprockets, page, asset)
        if page && sprockets.digest?
          site.regenerator.add_dependency(
            site.in_source_dir(page), site.in_source_dir(asset.logical_path)
          )
        end
      end

      private
      def find_asset(sprockets)
        if !(out = sprockets.find_asset(@args[:file], @args[:sprockets]))
          raise AssetNotFoundError, @args[:file]
        else
          out.liquid_tags << self
          if !@args.has_proxies?
            out else ProxiedAsset.new(
              out, @args, sprockets, self
            )
          end
        end
      end

      # There is no guarantee that Jekyll will pass on the error for
      # some reason (unless you are just booting up) so we capture that error
      # and always output it, it can lead to some double errors but
      # I would rather there be a double error than no error.

      private
      def capture_and_out_error(site, error)
        if error.is_a?(Sass::SyntaxError)
          file = error.sass_filename.gsub(/#{Regexp.escape(site.source)}\//, "")
          Jekyll.logger.error(%Q{Error in #{file}:#{error.sass_line}  #{error}})
        else
          Jekyll.logger.error \
            "", error.to_s
        end

        raise error
      end
    end
  end
end

%W(js css img image javascript stylesheet style asset_path).each do |t|
  Liquid::Template.register_tag t, Jekyll::Assets::Tag
end
