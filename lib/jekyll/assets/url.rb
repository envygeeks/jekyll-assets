# Frozen-string-literal: true
# Copyright: 2012 - 2020 - ISC License
# Encoding: utf-8

module Jekyll
  module Assets
    class Url < Sprockets::Asset
      alias hexdigest id
      alias digest_path filename
      alias url filename
      alias digest id

      def integrity
        ""
      end
    end
  end
end
