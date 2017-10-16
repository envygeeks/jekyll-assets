# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require_relative "extensible"
require "nokogiri"

module Jekyll
  module Assets
    class HTML < Extensible
      def initialize(doc:, **kwd)
        super(**kwd)
        @doc = doc
      end

      def self.build(type:, args:, asset:, env:)
        rtn = self.inherited.select do |o|
          o.for?({
            type: type,
            args: args,
          })
        end

        doc = make_doc(rtn, asset: asset)
        rtn.each do |o|
          o = o.new({
            doc: doc,
            args: args,
            asset: asset,
            env: env,
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

      def self.wants_xml?
        false
      end

      def self.make_doc(builders, asset:)
        wants = builders.map(&:wants_xml?).uniq
        raise RuntimeError, "incompatible wants xml/html for builders" if wants.size > 1
        !wants[0] ? Nokogiri::HTML::DocumentFragment.parse("") :
          Nokogiri::XML.parse(asset.to_s)
      end
    end
  end
end
