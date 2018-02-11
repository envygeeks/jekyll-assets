# Frozen-string-literal: true
# Copyright: 2012 - 2018 - MIT License
# Encoding: utf-8

require "forwardable/extended"
require "nokogiri"

module Helpers
  extend Forwardable::Extended
  rb_delegate :stub_jekyll_site, to: :Helpers
  rb_delegate :stub_env, to: :Helpers

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
    allow(jekyll).to(receive(:config)
      .and_return(hash))
  end

  def stub_asset_config(hash)
    hash = env.asset_config.deep_merge(hash)
    allow(env).to(receive(:asset_config)
      .and_return(hash))
  end

  def self.cleanup_trash
    Pathutil.new(fixture_path).join("_site").rm_rf
    %w(.jekyll-metadata .sass-cache .jekyll-cache).each do |v|
      Pathutil.pwd.join(v).rm_rf
    end
  end

  def self.stub_jekyll_site
    @jekyll ||= begin
      silence_stdout do
        cfg = Pathutil.new(fixture_path).join("_config.yml").read_yaml
        Jekyll::Site.new(Jekyll.configuration(cfg).update({
          "destination" => File.join(fixture_path, "_site"),
          "source" => fixture_path.to_s,
        })).tap(&:process)
      end
    end
  end

  def self.stub_env
    @env ||= begin
      Jekyll::Assets::Env.new(stub_jekyll_site)
    end
  end

  def self.fixture_path
    File.expand_path("../fixture", __dir__)
  end
end

RSpec.configure do |c|
  c.before(:suite) { Helpers.tap(&:cleanup_trash).stub_jekyll_site }
  c. after(:suite) { Helpers.cleanup_trash }
  c.include Helpers
  c.extend  Helpers
end
