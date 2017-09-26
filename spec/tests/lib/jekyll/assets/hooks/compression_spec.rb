# Frozen-string-literal: true
# Copyright: 2012 - 2016 - MIT License
# Encoding: utf-8

require "rspec/helper"
describe "asset compression" do
  let :env do
    Jekyll::Assets::Env.new(
      site
    )
  end

  #

  let :site do
    stub_jekyll_site
  end

  #

  it "compresses if asked to regardless of environment" do
    stub_asset_config "compress" => { "js" => true, "css" => true }
    expect(env. js_compressor).to eq Sprockets::UglifierCompressor
    expect(env.css_compressor).to eq Sprockets::SassCompressor
    expect(env.compress?("css")).to eq true
    expect(env.compress?("js")).to eq true
  end

  #

  it "does not default to compression in development" do
    expect(env. js_compressor).to be_nil
    expect(env.css_compressor).to be_nil
    expect(env.compress?("css")).to eq false
    expect(env.compress?("js")).to eq false
  end

  #

  it "defaults to compression being enabled in production" do
    allow(Jekyll).to receive(:env).and_return "production"
    expect(env. js_compressor).to eq Sprockets::UglifierCompressor
    expect(env.css_compressor).to eq Sprockets::SassCompressor
    expect(env.compress?("css")).to eq true
    expect(env.compress?("js")).to eq true
  end

  #

  it "allows you to disable compression in production" do
    allow(Jekyll).to receive(:env).and_return "production"
    stub_asset_config "compress" => {
      "js" => false, "css" => false
    }

    expect(env. js_compressor).to be_nil
    expect(env.css_compressor).to be_nil
    expect(env.compress?("css")).to eq false
    expect(env.compress?("js")).to eq false
  end

  #

  context "configuration" do
    let :env do
      Jekyll::Assets::Env.new(stub_jekyll_site("assets" => {
        "compress" => {
          "js" => true
        },

        "external" => {
          "uglifier" => {
            "mangle"  => {
              "toplevel" => true
            }
          }
        }
      }))
    end

    # ------------------------------------------------------------------------

    it "should let you configure Uglifier" do
      expect(Uglifier).to receive(:new).at_least(:once).with(:mangle => { :toplevel => true }).and_call_original
      expect(env.find_asset("compress.js").to_s).not_to start_with(
        "var hello="
      )
    end
  end
end
