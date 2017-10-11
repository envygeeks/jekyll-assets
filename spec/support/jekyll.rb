# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "nokogiri"

module Jekyll
  module RSpecHelpers
    def fragment(html)
      Nokogiri::HTML.fragment(html)
    end

    def self.silence_stdout()
      old_stdout = $stdout; old_stderr = $stderr
      $stdout = StringIO.new
      $stderr = StringIO.new
      yield
    ensure
      $stdout = old_stdout
      $stderr = old_stderr
    end

    def stub_jekyll_config(hash)
      hash = hash.deep_stringify_keys
      hash = Jekyll::Utils.deep_merge_hashes(jekyll.config, hash)
      allow(jekyll).to(receive(:config).and_return(hash))
    end

    def stub_asset_config(hash)
      allow(env).to(receive(:asset_config).and_return(
        env.asset_config.deep_merge(hash)))
    end

    def stub_jekyll_site(*args)
      RSpecHelpers.stub_jekyll_site(*args)
    end

    def self.cleanup_trash
      %W(.jekyll-metadata _site .jekyll-cache).each do |v|
        FileUtils.rm_rf(File.join(fixture, v))
      end
    end

    def self.stub_jekyll_site(opts = {})
      @jekyll ||= begin
        silence_stdout do
          dest = File.join(fixture, "_site")
          opts = Jekyll.configuration("destination" => dest, "source" => fixture)
          Jekyll::Site.new(opts).tap(&:reset).
            tap(&:read).tap(&:process).
            tap(&:render)
        end
      end
    end

    def self.fixture
      File.expand_path("../fixture", __dir__)
    end
  end

  module Declarations
    extend RSpec::SharedContext

    let(:sprockets) { env }
    subject { described_class }
    let(:env) { Jekyll::Assets::Env.new(jekyll) }
    let(:site) { stub_jekyll_site }
    let(:jekyll) { site }
  end
end

# --

RSpec.configure do |c|
  c.after (:suite) { Jekyll::RSpecHelpers.cleanup_trash }
  c.before(:suite) { Jekyll::RSpecHelpers.cleanup_trash }
  c.include Jekyll::RSpecHelpers
  c.include Jekyll::Declarations
  c.extend  Jekyll::RSpecHelpers
end
