module Jekyll::RSpecHelpers
  def silence_stdout(return_stringio = false)
    old_stdout, old_stderr = $stdout, $stderr
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

  def capture_stdout(&block)
    return silence_stdout(
      true, &block
    )
  end

  def strip_ansi(str)
    str.gsub(
      /\e\[(?:\d+)(?:;\d+)?m/, ""
    )
  end

  def stub_jekyll_site(oth_opts = {})
    opts = Jekyll::Utils.deep_merge_hashes(
      Jekyll::Configuration::DEFAULTS, {
        "full_rebuild" => true,
        "source"       => File.expand_path("../../fixture",       __FILE__),
        "destination"  => File.expand_path("../../fixture/_site", __FILE__)
      }
    )

    Jekyll::Site.new(
      Jekyll::Utils.deep_merge_hashes(
        opts, oth_opts
      )
    )
  end

  def get_stubbed_file(file)
    File.read(
      File.join(
        File.expand_path("../../fixture/_site", __FILE__), file
      )
    )
  end

  class << self
    def cleanup_trash
      %W(.asset-cache .jekyll-metadata _site).each do |v|
        FileUtils.rm_rf(
          File.join(
            File.expand_path("../../fixture", __FILE__), v
          )
        )
      end
    end
  end
end

RSpec.configure do |c|
  c.include Jekyll::RSpecHelpers
  c.before(:each) { Jekyll::RSpecHelpers.cleanup_trash }
  c.after (:each) { Jekyll::RSpecHelpers.cleanup_trash }
end
