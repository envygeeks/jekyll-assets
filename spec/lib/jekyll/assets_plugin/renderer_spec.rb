# stdlib
require "ostruct"

require "spec_helper"

RSpec.describe Jekyll::AssetsPlugin::Renderer do
  let(:site) do
    Jekyll::Site.new Jekyll.configuration({
      "source"      => fixtures_path.to_s,
      "destination" => @dest.to_s,
      "assets"      => assets_config
    })
  end

  let(:renderer) do
    context = OpenStruct.new(:registers => { :site => site })
    described_class.new context, asset
  end

  let(:asset) { "app" }

  describe "#render_javascript" do
    subject { renderer.render_javascript }

    context "when debug mode enabled" do
      let(:assets_config) { Hash[:debug, true] }
      it { is_expected.to match(/^(\s*<script src="[^"]+"><\/script>\s*){3}$/) }

      context "and URI given" do
        let(:asset) { "http://example.com/app.js" }
        it { is_expected.to match(/^<script src="#{asset}"><\/script>$/) }
      end

      context "and path contains attributes" do
        let(:asset) { "app data-test=true" }
        it { is_expected.to include "data-test=true" }
      end
    end

    context "when debug mode disabled" do
      let(:assets_config) { Hash[:debug, false] }
      it { is_expected.to match(/^(\s*<script src="[^"]+"><\/script>\s*){1}$/) }

      context "and URI given" do
        let(:asset) { "http://example.com/app.js" }
        it { is_expected.to match(/^<script src="#{asset}"><\/script>$/) }
      end

      context "and path contains attributes" do
        let(:asset) { "app data-test=true" }
        it { is_expected.to include "data-test=true" }
      end
    end
  end

  describe "#render_stylesheet" do
    subject { renderer.render_stylesheet }

    context "when debug mode enabled" do
      let(:assets_config) { Hash[:debug, true] }
      it { is_expected.to match(/^(\s*<link rel="stylesheet" [^>]+>\s*){3}$/) }

      context "and URI given" do
        let(:asset) { "http://example.com/style.css" }
        it { is_expected.to match(/^<link rel="stylesheet" href="#{asset}">$/) }
      end

      context "and path contains attributes" do
        let(:asset) { "app data-test=true" }
        it { is_expected.to include "data-test=true" }
      end
    end

    context "when debug mode disabled" do
      let(:assets_config) { Hash[:debug, false] }
      it { is_expected.to match(/^(\s*<link rel="stylesheet" [^>]+>\s*){1}$/) }

      context "and URI given" do
        let(:asset) { "http://example.com/style.css" }
        it { is_expected.to match(/^<link rel="stylesheet" href="#{asset}">$/) }
      end

      context "and path contains attributes" do
        let(:asset) { "app data-test=true" }
        it { is_expected.to include "data-test=true" }
      end
    end
  end

  describe "#render_image" do
    subject { renderer.render_image }

    let(:asset) { "noise.png" }

    context "when debug mode enabled" do
      let(:assets_config) { Hash[:debug, true] }
      it { is_expected.to match(%r{^<img src="/assets/noise-[^.]+\.png">$}) }

      context "and URI given" do
        let(:asset) { "http://example.com/style.css" }
        it { is_expected.to match(/^<img src="#{asset}">$/) }
      end

      context "and path contains attributes" do
        let(:asset) { "noise.png data-test=true" }
        it { is_expected.to include "data-test=true" }
      end
    end

    context "when debug mode disabled" do
      let(:assets_config) { Hash[:debug, false] }
      it { is_expected.to match(%r{^<img src="/assets/noise-[^.]+\.png">$}) }

      context "and URI given" do
        let(:asset) { "http://example.com/style.css" }
        it { is_expected.to match(/^<img src="#{asset}">$/) }
      end

      context "and path contains attributes" do
        let(:asset) { "noise.png data-test=true" }
        it { is_expected.to include "data-test=true" }
      end
    end
  end

  describe "#render_asset" do
    subject { renderer.render_asset }
    let(:asset) { "alert.js" }

    context "when debug mode enabled" do
      let(:assets_config) { Hash[:debug, true] }
      it { is_expected.to eq "alert('test');\n" }

      context "and URI given" do
        let(:asset) { "http://example.com/style.css" }
        it { expect { subject }.to raise_error(/#{asset}/) }
      end
    end

    context "when debug mode disabled" do
      let(:assets_config) { Hash[:debug, false] }
      it { is_expected.to eq "alert('test');\n" }

      context "and URI given" do
        let(:asset) { "http://example.com/style.css" }
        it { expect { subject }.to raise_error(/#{asset}/) }
      end
    end
  end
end
