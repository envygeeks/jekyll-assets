# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "pathutil"
require_relative "../utils"
require "jekyll/assets"
require "jekyll"

module Jekyll
  module Assets
    module Plugins
      # --
      # Searches for `<img>` that have `<img asset>` or
      # `<img asset="args">` and runs them through the asset
      # system.  This allows you to use real assets inside
      # of your Markdown pre-convert.
      # --
      class Searcher
        def initialize(doc)
          @doc = doc
        end

        # --
        def run
          html.search("img[@asset]").each do |v|
            raise ArgumentError, "src is empty" unless v[:src]
            args = "#{v.delete('src')&.value} #{v.delete('asset')&.value}"
            pctx = ::Liquid::ParseContext.new

            attrs = v.attributes.keys
            args, = Tag.new("asset", args, pctx).render_raw(ctx)
            args.to_h(html: true).each do |k, vv|
              unless attrs.include?(k.to_s)
                v.set_attribute(k, vv)
              end
            end
          end

          out = html.to_html
          @doc.output = out
        end

        # --
        private
        def ctx
          ::Liquid::Context.new({}, {}, {
            site: @doc.site,
          })
        end

        # --
        private
        def html
          @html ||= begin
            out = @doc.output
            # @see https://github.com/sparklemotion/nokogiri/issues/553
            good, buggy = Encoding::UTF_8, Encoding::ASCII_8BIT
            out = out.encode good if out.encoding == buggy
            Utils.send((@doc.output.strip =~ %r!<\!doctype\s+!i ? \
              :html : :html_fragment), out)
          end
        end
      end
    end
  end
end

# --
Jekyll::Assets::Hook.register :config, :before_merge do |c|
  c.deep_merge!({
    plugins: {
      img: {
        searcher: false,
      },
    },
  })
end

# --
Jekyll::Hooks.register %i(pages documents posts), :post_render do |d|
  if d.site.sprockets.asset_config["plugins"]["img"]["searcher"]
    if d.output_ext == ".html"
      Jekyll::Assets::Plugins::Searcher.new(d).run
    end
  end
end
