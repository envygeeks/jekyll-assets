# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    module Patches
      module ObsoleteFiles

        # --
        # @note we don't want our files removed.
        # obsolete_files patches Jekyll's obsolete_files
        # @return [Array]
        # --
        def obsolete_files
          super.reject do |v|
            v.start_with?(site.in_dest_dir(site.sprockets.
              prefix_path))
          end
        end
      end
    end
  end
end

# --
module Jekyll
  class Cleaner
    prepend Jekyll::Assets::Patches::ObsoleteFiles
  end
end
