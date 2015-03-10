# stdlib
require "ostruct"

require "spec_helper"

RSpec.describe Jekyll::Assets::Renderer do
  let(:assets_config) { Hash.new }

  let(:site) do
    Jekyll::Site.new Jekyll.configuration({
      "source"      => fixtures_path.to_s,
      "destination" => @dest.to_s,
      "assets"      => assets_config
    })
  end

  let(:params)   { "app" }
  let(:context)  { OpenStruct.new(:registers => { :site => site }) }
  let(:renderer) { described_class.new context, params }

  describe "#path" do
    subject { renderer.path }

    context "with logical path only" do
      context "when logical path contains no spaces" do
        let(:params) { "app" }
        it { is_expected.to eq "app" }
      end

      context "when logical path contains spaces and double quoted" do
        let(:params) { '"my app"' }
        it { is_expected.to eq "my app" }
      end

      context "when logical path contains spaces and single quoted" do
        let(:params) { "'my app'" }
        it { is_expected.to eq "my app" }
      end
    end

    context "with logical path and params" do
      context "when logical path contains no spaces" do
        let(:params) { 'app foo bar="baz"' }
        it { is_expected.to eq "app" }
      end

      context "when logical path contains spaces and double quoted" do
        let(:params) { '"my app" foo bar="baz"' }
        it { is_expected.to eq "my app" }
      end

      context "when logical path contains spaces and single quoted" do
        let(:params) { %q('my app' foo bar="baz") }
        it { is_expected.to eq "my app" }
      end
    end
  end

  describe "#attrs" do
    subject { renderer.attrs }

    context "with logical path only" do
      context "when logical path contains no spaces" do
        let(:params) { "app" }
        it { is_expected.to eq "" }
      end

      context "when logical path contains spaces and double quoted" do
        let(:params) { '"my app"' }
        it { is_expected.to eq "" }
      end

      context "when logical path contains spaces and single quoted" do
        let(:params) { "'my app'" }
        it { is_expected.to eq "" }
      end
    end

    context "with logical path and params" do
      context "when logical path contains no spaces" do
        let(:params) { 'app foo bar="baz"' }
        it { is_expected.to eq ' foo bar="baz"' }
      end

      context "when logical path contains spaces and double quoted" do
        let(:params) { '"my app" foo bar="baz"' }
        it { is_expected.to eq ' foo bar="baz"' }
      end

      context "when logical path contains spaces and single quoted" do
        let(:params) { %q('my app' foo bar="baz") }
        it { is_expected.to eq ' foo bar="baz"' }
      end
    end
  end

  describe "#options" do
    subject { renderer.options }

    context "with no options given" do
      it { is_expected.to be_an Array }
      it { is_expected.to be_empty }
    end

    context "with options given" do
      let(:params) { "app [foo,bar]" }
      it { is_expected.to eq %w(foo bar) }
    end
  end

  describe "#render_javascript" do
    subject { renderer.render_javascript }

    context "when debug mode enabled" do
      let(:assets_config) { Hash[:debug, true] }
      it { is_expected.to match(/^(\s*<script src="[^"]+"><\/script>\s*){3}$/) }

      context "and URI given" do
        let(:params) { "http://example.com/app.js" }
        it { is_expected.to match(/^<script src="#{params}"><\/script>$/) }
      end

      context "and path contains attributes" do
        let(:params) { "app data-test=true" }
        it { is_expected.to include "data-test=true" }
      end
    end

    context "when debug mode disabled" do
      let(:assets_config) { Hash[:debug, false] }
      it { is_expected.to match(/^(\s*<script src="[^"]+"><\/script>\s*){1}$/) }

      context "and URI given" do
        let(:params) { "http://example.com/app.js" }
        it { is_expected.to match(/^<script src="#{params}"><\/script>$/) }
      end

      context "and path contains attributes" do
        let(:params) { "app data-test=true" }
        it { is_expected.to include "data-test=true" }
      end
    end
  end

  describe "#render_stylesheet" do
    subject { renderer.render_stylesheet }
    let(:tag_prefix) { '<link rel="stylesheet"' }

    context "when debug mode enabled" do
      let(:assets_config) { Hash[:debug, true] }
      it { is_expected.to match(/^(\s*#{tag_prefix} [^>]+>\s*){3}$/) }

      context "and URI given" do
        let(:params) { "http://example.com/style.css" }
        it { is_expected.to match(/^#{tag_prefix} href="#{params}">$/) }
      end

      context "and path contains attributes" do
        let(:params) { "app data-test=true" }
        it { is_expected.to include "data-test=true" }
      end
    end

    context "when debug mode disabled" do
      let(:assets_config) { Hash[:debug, false] }
      it { is_expected.to match(/^(\s*#{tag_prefix} [^>]+>\s*){1}$/) }

      context "and URI given" do
        let(:params) { "http://example.com/style.css" }
        it { is_expected.to match(/^#{tag_prefix} href="#{params}">$/) }
      end

      context "and path contains attributes" do
        let(:params) { "app data-test=true" }
        it { is_expected.to include "data-test=true" }
      end
    end
  end

  describe "#render_image" do
    subject { renderer.render_image }

    let(:params) { "noise.png" }

    context "when debug mode enabled" do
      let(:assets_config) { Hash[:debug, true] }
      it { is_expected.to match(%r{^<img src="/assets/noise-[^.]+\.png">$}) }

      context "and URI given" do
        let(:params) { "http://example.com/style.css" }
        it { is_expected.to match(/^<img src="#{params}">$/) }
      end

      context "and path contains attributes" do
        let(:params) { "noise.png data-test=true" }
        it { is_expected.to include "data-test=true" }
      end
    end

    context "when debug mode disabled" do
      let(:assets_config) { Hash[:debug, false] }
      it { is_expected.to match(%r{^<img src="/assets/noise-[^.]+\.png">$}) }

      context "and URI given" do
        let(:params) { "http://example.com/style.css" }
        it { is_expected.to match(/^<img src="#{params}">$/) }
      end

      context "and path contains attributes" do
        let(:params) { "noise.png data-test=true" }
        it { is_expected.to include "data-test=true" }
      end
    end

    context "with [autosize] helper option" do
      let(:params)    { "noise.png [autosize]" }
      let(:attr_src)  { 'src="/assets/noise-[^.]+\.png"' }
      let(:attr_size) { 'width="100" height="100"' }

      it { is_expected.to match(/^<img #{attr_src} #{attr_size}>$/) }
    end

    context "with [no-autosize] helper option" do
      let(:params)    { "noise.png [no-autosize]" }
      let(:attr_src)  { 'src="/assets/noise-[^.]+\.png"' }

      it { is_expected.to match(/^<img #{attr_src}>$/) }
    end

    context "with autosize enabled in config" do
      let(:assets_config) { Hash[:autosize, true] }
      let(:attr_src)      { 'src="/assets/noise-[^.]+\.png"' }
      let(:attr_size)     { 'width="100" height="100"' }

      it { is_expected.to match(/^<img #{attr_src} #{attr_size}>$/) }

      context "and [autosize] helper option given" do
        let(:params) { "noise.png [autosize]" }
        it { is_expected.to match(/^<img #{attr_src} #{attr_size}>$/) }
      end

      context "and [no-autosize] helper option given" do
        let(:params) { "noise.png [no-autosize]" }
        it { is_expected.to match(/^<img #{attr_src}>$/) }
      end
    end

    context "with [resize:*] helper option" do
      let(:params)    { "noise.png [resize:10x10]" }
      let(:attr_src)  { 'src="/assets/noise-10x10-[^.]+\.png"' }
      it { is_expected.to match(/^<img #{attr_src}>$/) }
    end

    context "with [resize:*] and [autosize] helpers" do
      let(:params)    { "noise.png [resize:10x10, autosize]" }
      let(:attr_src)  { 'src="/assets/noise-10x10-[^.]+\.png"' }
      let(:attr_size) { 'width="10" height="10"' }
      it { is_expected.to match(/^<img #{attr_src} #{attr_size}>$/) }
    end
  end

  describe "#render_asset" do
    subject { renderer.render_asset }
    let(:params) { "alert.js" }

    context "when debug mode enabled" do
      let(:assets_config) { Hash[:debug, true] }
      it { is_expected.to eq "alert('test');\n" }

      context "and URI given" do
        let(:params) { "http://example.com/style.css" }
        it { expect { subject }.to raise_error(/#{params}/) }
      end
    end

    context "when debug mode disabled" do
      let(:assets_config) { Hash[:debug, false] }
      it { is_expected.to eq "alert('test');\n" }

      context "and URI given" do
        let(:params) { "http://example.com/style.css" }
        it { expect { subject }.to raise_error(/#{params}/) }
      end
    end
  end
end
