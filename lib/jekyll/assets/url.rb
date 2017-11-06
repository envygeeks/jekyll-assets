# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    # --
    # Inherits from and overrides some of Sprockets asset,
    #   this way we can have some external assets that do not
    #   break the way we work or the way Sprockets works.
    # --
    class Url < Sprockets::Asset
      alias hexdigest id
      alias digest_path filename
      alias url filename
      alias digest id

      def integrity
        nil
      end
    end
  end
end
