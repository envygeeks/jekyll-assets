# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require_relative "extensible"
require "nokogiri"

module Jekyll
  module Assets
    class HTML < Extensible
      attr_reader :doc

      # --
      def self.skips
        %i(inline path data pic) | Proxy.keys
      end

      # --
      def initialize(doc:, **kwd)
        super(**kwd)
        @doc = doc
      end

      # --
      # @param [Hash] args the arguments.
      # @param [String] type the content type.
      # Search for plugins and runners and then run them.
      # @param [Sprockets::Asset] the current asset.
      # @note look inside of plugins for examples.
      # @return [String] the final result.
      # @param [Env] env the env.
      # --
      def self.build(args:, asset:, ctx:)
        rtn = inherited.select do |o|
          o.for?({
            type: asset.content_type,
            args: args,
          })
        end

        doc = make_doc(rtn, asset: asset)
        rtn.each do |o|
          o = o.new({
            doc: doc,
            asset: asset,
            args: args,
            ctx: ctx,
          })

          o.run
        end

        # SVG will need to_xml!
        out = doc.is_a?(Nokogiri::XML::Document) ? doc.to_xml : doc.to_html
        rtn.select { |v| v.respond_to?(:cleanup) }.each do |o|
          out = o.cleanup(out)
        end
        out
      end

      # --
      # Allows a plugin to inform us if they want XML.
      # @note technically this can break sub-plugins later.
      # @return [true, false]
      # --
      def self.wants_xml?
        false
      end

      # --
      # Make an HTML/XML doc to work on.
      # @note see `self.wants_html?` to control this.
      # @return [Nokogiri::Document]
      # --
      def self.make_doc(builders, asset:)
        wants = builders.map(&:wants_xml?).uniq
        raise "incompatible wants xml/html for builders" if wants.size > 1
        !wants[0] ? Utils.html_fragment("") : Utils.xml(asset.to_s)
      end
    end
  end
end
