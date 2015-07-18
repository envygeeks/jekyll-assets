module Jekyll
  class Cleaner
    alias_method :_old_obsolete_files, :obsolete_files

    # TODO: jekyll/jekyll@upstream: This method should really have a hook ya.

    def obsolete_files
      _old_obsolete_files.delete_if do |v|
        v =~ %r!\A#{Regexp.escape(site.in_dest_dir("assets"))}(\/.*)?\Z!
      end
    end
  end
end
