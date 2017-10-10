# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require_relative "extensible"

module Jekyll
  module Assets
    class HTML < Extensible
      def self.build(type:, args:, asset:, env:)
        rtn = self.inherited.select do |o|
          o.for?({
            type: type,
            args: args,
          })
        end

        # We are the base builer.
        rtn = rtn.sort_by do |v|
          v.name.start_with?("Jekyll::Assets") ? 1 : -1
        end

        doc = nil
        rtn.each do |o|
          o = o.new({
            args: args,
            asset: asset,
            env: env,
          })

          doc = o.run
        end

        # SVG will need to_xml!
        doc.is_a?(Nokogiri::XML::Document) ?
          doc.to_xml : doc.to_html
      end
    end
  end
end
