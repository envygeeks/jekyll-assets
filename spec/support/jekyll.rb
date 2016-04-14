# ----------------------------------------------------------------------------
# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8
# ----------------------------------------------------------------------------

require "nokogiri"

module Jekyll
  module RSpecHelpers
    class ContextThief < Liquid::Tag
      class << self
        attr_accessor :context
      end

      # ----------------------------------------------------------------------

      def render(context)
        return self.class.context = context
      end
    end

    # ------------------------------------------------------------------------
    # Allows you to get a real context context, to test methods directly
    # if you need to, most can be tested indirectly.
    # ------------------------------------------------------------------------

    def build_context
      site = stub_jekyll_site
      site.liquid_renderer.file("").parse("{% context_thief %}") \
        .render!(site.site_payload, :registers => { :site => site })
      ContextThief.context
    end

    # ------------------------------------------------------------------------

    def fragment(html)
      Nokogiri::HTML.fragment(html)
    end

    # ------------------------------------------------------------------------
    # Allows you to run something capturing all errors and output so you can
    # run a test cleanly without a bunch of noise, nobody likes noise when they
    # are just trying to see the result of a failed test.
    # ------------------------------------------------------------------------

    def silence_stdout(return_stringio = false)
      old_stdout = $stdout; old_stderr = $stderr
      $stdout = stdout = StringIO.new
      $stderr = stderr = StringIO.new
      output  = yield

      if return_stringio
        return [
          stdout.string,
          stderr.string
        ]
      else
        return output
      end
    ensure
      $stdout = old_stdout
      $stderr = old_stderr
    end

    # ------------------------------------------------------------------------
    # Uses `#silence_stdout` to return output to you without you having
    # to use true or false on `#silence_stoudt`.
    # ------------------------------------------------------------------------

    def capture_stdout(&block)
      silence_stdout true, &block
    end

    # ------------------------------------------------------------------------
    # Stubs the asset config on Jekyll for you, this is meant to be used
    # in a new context or at the top of a context so that you can stub the
    # configuration and have it reset afterwards.
    # ------------------------------------------------------------------------

    def stub_asset_config(inst, hash = nil)
      (hash = inst; inst = nil) if inst.is_a?(Hash)
      inst = @site || site unless inst

      hash = Jekyll::Assets::Config.merge(hash)
      allow(inst).to receive(:config).and_return(inst.config.merge({
        "assets" => hash
      }))
    end

    # ------------------------------------------------------------------------

    def stub_env_config(inst, hash = nil)
      (hash = inst; inst = nil) if inst.is_a?(Hash)
      inst = @env || env unless inst

      hash = Jekyll::Utils.deep_merge_hashes(inst.asset_config, hash)
      allow(inst).to receive(:asset_config).and_return(hash)
    end

    # ------------------------------------------------------------------------
    # Strips ANSI from the output so that you can test just a plain text
    # string without worrying about whether colors are there or not, this is
    # mostly useful for testing log output or other helpers.
    # ------------------------------------------------------------------------

    def strip_ansi(str)
      str.gsub(/\e\[(?:\d+)(?:;\d+)?m/, "")
    end

    # ------------------------------------------------------------------------
    # Stubs the Jekyll site with your configuration, most of the time you
    # won't do it this way though, because you can just initialize the default
    # configuration with our merges and stub the configuration pieces.
    # ------------------------------------------------------------------------

    def stub_jekyll_site(opts = {})
      path = File.expand_path("../../fixture", __FILE__)
      Jekyll::RSpecHelpers.cleanup_trash

      silence_stdout do
        Jekyll::Site.new(Jekyll.configuration(opts.merge({
          "source" => path, "destination" => File.join(path, "_site")
        }))).tap(&:read)
      end
    end

    # ------------------------------------------------------------------------
    # See: `#stub_jekyll_site` except this also kicks a process so that
    #   do both the building and the processing all in one shot.
    # ------------------------------------------------------------------------

    def stub_jekyll_site_with_processing(oth_opts = {})
      site = stub_jekyll_site(oth_opts)
      silence_stdout { site.process }
      site
    end

    # ------------------------------------------------------------------------
    # Pulls a file and passes the data to you (from _site), this does
    # no checking so it will raise an error if there is no file that you wish
    # to pull, so beware of that when testing.
    # ------------------------------------------------------------------------

    def get_stubbed_file(file)
      path = File.expand_path("../../fixture/_site", __FILE__)
      File.read(File.join(path, file))
    end

    # ------------------------------------------------------------------------
    # Cleanup after ourselves when testing, removing the data that we and
    # through us Jekyll created, so that if we test again there is nothing but
    # clean data to test with, and not dirty old data.
    # ------------------------------------------------------------------------

    def self.cleanup_trash
      %W(.asset-cache .jekyll-metadata _site).each do |v|
        FileUtils.rm_rf(File.join(File.expand_path("../../fixture", __FILE__), v))
      end
    end
  end
end

# ----------------------------------------------------------------------------

Liquid::Template.register_tag "context_thief", \
  Jekyll::RSpecHelpers::ContextThief

# ----------------------------------------------------------------------------

RSpec.configure do |c|
  c.include Jekyll::RSpecHelpers
  c.before :all do
    Jekyll::RSpecHelpers.cleanup_trash
  end

  #

  c.after :all do
    Jekyll::RSpecHelpers.cleanup_trash
  end
end
