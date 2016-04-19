# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

module Jekyll
  class Cleaner
    alias _old_obsolete_files obsolete_files

    def obsolete_files
      root_path = site.sprockets.asset_config["prefix"]
      root_path = site.in_dest_dir(root_path)

      _old_obsolete_files.delete_if do |path|
        Pathutil.new(path).in_path?(
          root_path
        )
      end
    end
  end
end
