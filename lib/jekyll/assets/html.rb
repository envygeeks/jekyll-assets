# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require_relative "extensible"

module Jekyll
  module Assets
    class HTML < Extensible
      def initialize(doc:, **kwd)
        super(**kwd)
        @doc = doc
      end

      def self.build(type:, args:, asset:, env:)
        doc = make_doc(asset: asset, type: type)
        rtn = self.inherited.select do |o|
          o.for?({
            type: type,
            args: args,
          })
        end

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
        doc.is_a?(Nokogiri::XML::Document) ?
          doc.to_xml : doc.to_html
      end

      def self.make_doc(type:, asset:)
        type == "image/svg+xml" ? Nokogiri::XML.parse(asset.to_s) :
          Nokogiri::HTML::DocumentFragment.parse("")
      end
    end
  end
end
