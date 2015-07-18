module Jekyll
  module Assets
    class Tag < Liquid::Tag
      require_relative "tag/parser"

      class AssetNotFoundError < StandardError
        def initialize(asset)
          super "Could not find the asset `#{asset}'"
        end
      end

      TAGS  = {
        "css" => %Q{<link type="text/css" rel="stylesheet" href="%s"%s>},
        "js"  => %Q{<script type="text/javascript" src="%s"%s></script>},
        "img" => %Q{<img src="%s"%s>}
      }

      TAGS["javascript"] = TAGS[ "js"]
      TAGS["image"]      = TAGS["img"]
      TAGS["style"]      = TAGS["css"]
      TAGS["stylesheet"] = TAGS["css"]
      TAGS.freeze

      def initialize(tag, args, tokens)
        @tokens, @tag, @url_options = tokens, tag, {}
        @args = Parser.new(
          args, tag
        )

        super
      rescue => e
        Jekyll.logger.error(e.to_s)
        raise(
          e
        )
      end

      # -----------------------------------------------------------------------
      # NOTE: We only attach to the regenerator if you are using digested
      #       assets, otherwise we forego any association with it so that we
      #       keep your builds ultra fast, this is ideal in dev.  Disable
      #       digests and let us process independent so the entire site
      #       isn't regenerated because of a single asset change.
      # -----------------------------------------------------------------------

      def render(context)
        site = context.registers[:site]
        page = context.registers.fetch(:page, {}).fetch("path", nil)
        sprockets = site.sprockets

        asset = find_asset(sprockets)
        add_as_jekyll_dependency(site, sprockets, page, asset)
        process_tag(sprockets, asset)
      rescue => e
        capture_and_out_error(
          site, e
        )
      end

      private
      def process_tag(sprockets, asset)
        if @tag == "asset_path"
          return path(
            sprockets, asset
          )
        else
          sprockets.used.add(asset)
          return TAGS[@tag] % [
            path(sprockets, asset), @args.\
              to_html
          ]
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
        if !(asset = sprockets.find_asset(@args[:file], \
              @args[:proxy][:find]))

          raise AssetNotFoundError, @args[
            :file
          ]
        else
          asset.metadata[:write_options] = \
            @args[:proxy][:write]
          asset
        end
      end

      private
      def path(sprockets, asset)
        File.join(
          sprockets.asset_config.fetch("prefix", "/assets"), (
            sprockets.digest?? asset.digest_path : asset.logical_path
          )
        )
      end

      private
      def capture_and_out_error(site, error)
        if error.is_a?(Sass::SyntaxError)
          file = error.sass_filename.gsub(/#{Regexp.escape(site.source)}\//, "")
          Jekyll.logger.error(%Q{Error in #{file}:#{error.sass_line}  #{error}})
        else
          Jekyll.logger.error(
            error.to_s
          )
        end

        raise(
          error
        )
      end
    end
  end
end

(Jekyll::Assets::Tag::TAGS.keys + ["asset_path"]).each do |t|
  Liquid::Template.register_tag(
    t, Jekyll::Assets::Tag
  )
end
