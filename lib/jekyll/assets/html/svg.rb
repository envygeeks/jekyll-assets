# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class HTML
      class SVG < HTML
        types "image/svg+xml"

        def run
          doc = Nokogiri::XML.parse(@asset.to_s)
          arg = @args.to_html(hash: true)
          arg.each do |k, v|
            doc.set_attribute(k, v)
          end

          doc
        end
      end
    end
  end
end
