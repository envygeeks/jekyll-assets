# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8

module Jekyll
  module Assets
    class Manifest < Sprockets::Manifest
      extend Forwardable::Extended
      rb_delegate :add, {
        :to => :used
      }

      # --
      # The assets to be compiled.
      # @return [Set]
      # --
      def used
        return @used ||= Set.new
      end

      # --
      # All the assets, plus the used.
      # @return [Set]
      # --
      def all
        used | (files.map do |_, v|
          find(v["logical_path"]).first if v
        end).compact
      end

      # --
      # This is a wholesale rip of Sprockets::Manifest#compkle, we only
      # adjust it to care about whether or not we want to digest, we don't
      # always digest in development.
      # --
      def compile(*args)
        unless environment
          raise(
            Error, "manifest requires environment for compilation"
          )
        end

        # --

        filenames = []
        concurrent_compressors = []
        concurrent_writers = []

        # --

        find(*args) do |asset|
          files[asset.digest_path] = {
            "mtime" => asset.mtime.iso8601,
            "logical_path" => asset.logical_path,
            "integrity"  => Sprockets::DigestUtils.hexdigest_integrity_uri(asset.hexdigest),
            "digest" => asset.hexdigest,
            "size" => asset.bytesize
          }

          # --

          assets[asset.logical_path] = asset.digest_path
          alias_logical_path = self.class.compute_alias_logical_path(
            asset.logical_path
          )

          # --

          if alias_logical_path
            assets[alias_logical_path] = asset.digest_path
          end

          # Unlike upstream, we allow users to disble digesting, this is
          # where we actually and truthfully only diverge from upstream in
          # that we disable or enable the digested or logical path.

          target = \
          if environment.digest?
            File.join(dir,
              asset.digest_path
            )
          else
            File.join(dir,
              asset.logical_path
            )
          end

          # --

          if !environment.digest? || !File.exist?(target)
            logger.info "Writing #{target}"
            write_file = Concurrent::Future.execute { asset.write_to target }
            concurrent_writers << write_file

          else
            logger.debug(
              "Skipping #{target}, already exists"
            )
          end

          # --

          filenames << asset.filename
          next if environment.skip_gzip?
          gzip = Utils::Gzip.new(asset)
          next if gzip.cannot_compress?(
            environment.mime_types
          )

          # This is technically ignored usptream, we don't allow our
          # assets to write `.tar.gz` files by default, however, we leave
          # this here just incase someobody overrides that method.

          if File.exist?("#{target}.gz")
            logger.debug(
              "Skipping #{target}.gz, already exists"
            )
          else
            logger.info "Writing #{target}.gz"
            concurrent_compressors << Concurrent::Future.execute do
              write_file.wait! if write_file
              gzip.compress(
                target
              )
            end
          end
        end

        # --

        concurrent_writers.each(&:wait!)
        concurrent_compressors.each(
          &:wait!
        )

        # --

        save
        filenames
      end
    end
  end
end
