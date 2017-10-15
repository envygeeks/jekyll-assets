# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

require "forwardable/extended"
require "nokogiri"

module Jekyll
  module RSpecHelpers
    extend Forwardable::Extended
    rb_delegate :stub_jekyll_site, to: :"Jekyll::RSpecHelpers"
    rb_delegate :stub_environment, to: :"Jekyll::RSpecHelpers"

    def fragment(html)
      Nokogiri::HTML.fragment(html)
    end

    def self.silence_stdout
      stdout, stderr = $stdout, $stderr
      $stdout = StringIO.new
      $stderr = StringIO.new

      yield
    ensure
      $stdout = stdout
      $stderr = stderr
    end

    def stub_jekyll_config(hash)
      hash = hash.deep_stringify_keys
      hash = jekyll.config.deep_merge(hash)
      allow(jekyll).to(receive(:config).
        and_return(hash))
    end

    def stub_asset_config(hash)
      hash = environment.asset_config.deep_merge(hash)
      allow(env).to(receive(:asset_config).
        and_return(hash))
    end

    def self.cleanup_trash
      %W(.jekyll-metadata _site .jekyll-cache).each do |v|
        Pathutil.new(fixture_path).join(v).rm_rf
      end
    end

    def self.stub_jekyll_site(opts = {})
      @jekyll ||= begin
        silence_stdout do
          dest = File.join(fixture_path, "_site")
          Jekyll::Site.new(Jekyll.configuration({
            "destination" => dest, "source" => fixture_path
          })).tap(&:process)
        end
      end
    end

    def self.stub_environment
      @environment ||= begin
        Jekyll::Assets::Env.new(stub_jekyll_site)
      end
    end

    def self.fixture_path
      File.expand_path("../fixture", __dir__)
    end
  end

  module Declarations
    extend RSpec::SharedContext

    let(:sprockets) { env }
    subject { described_class }
    let(:environment) { stub_environment }
    let(:site) { stub_jekyll_site }
    let(:jekyll) { site }
  end
end

# --

RSpec.configure do |c|
  # c.after (:suite) {  Jekyll::RSpecHelpers.cleanup_trash }
  c.before(:suite) do Jekyll::RSpecHelpers.cleanup_trash
    Jekyll::RSpecHelpers.stub_jekyll_site
  end

  c.include Jekyll::RSpecHelpers
  c.include Jekyll::Declarations
  c.extend  Jekyll::RSpecHelpers
end
