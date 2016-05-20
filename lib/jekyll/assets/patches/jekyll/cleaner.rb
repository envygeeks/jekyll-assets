module JekyllAssetsPatchesJekyllCleaner
  def obsolete_files
    super.delete_if do |v|
      v.start_with?(site.in_dest_dir(
        site.sprockets.prefix_path
      ))
    end
  end
end

module Jekyll
  class Cleaner
    prepend JekyllAssetsPatchesJekyllCleaner
  end
end
