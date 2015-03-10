require "spec_helper"

RSpec.describe Jekyll::Assets::Configuration do
  let(:options)     { {} }
  subject(:config)  { described_class.new(@site, options) }

  context "with defaults" do
    context "output assets dirname" do
      subject { config.dirname }
      it { is_expected.to eq described_class::DEFAULTS[:dirname] }
    end

    context "assets baseurl" do
      subject { config.baseurl }
      it { is_expected.to eq "/" + described_class::DEFAULTS[:dirname] }
    end

    context "sources list" do
      subject { config.sources }
      it { is_expected.to match_array described_class::DEFAULTS[:sources] }
    end

    context "cachebust" do
      subject { config.cachebust }
      it { is_expected.to be :hard }
    end

    context "js compressor" do
      subject { config.js_compressor }
      it { is_expected.to be_nil }
    end

    context "css compressor" do
      subject { config.css_compressor }
      it { is_expected.to be_nil }
    end

    context "autosize" do
      subject { config.autosize }
      it { is_expected.to be false }
    end

    context "gzip" do
      subject { config.gzip }
      it { is_expected.to match_array %w(text/css application/javascript) }
    end

    context "cache_assets?" do
      subject { config.cache_assets? }
      it { is_expected.to be false }
    end

    context "cache_path" do
      subject { config.cache_path }
      it { is_expected.to eq ".jekyll-assets-cache" }
    end

    context "debug" do
      subject { config.debug }
      it { is_expected.to be false }
    end
  end

  it "overrides specified options and leave defaults for missing" do
    config = described_class.new(@site, {
      :sources        => %w(abc),
      :css_compressor => "sass"
    })

    expect(config.dirname).to eq "assets"
    expect(config.sources).to eq %w(abc)
    expect(config.js_compressor).to be_nil
    expect(config.css_compressor).to be  :sass
  end

  context "#cache" do
    context "when specified as String" do
      let(:options) { { :cache => "/tmp/jekyll-assets" } }

      it "overrides default cache path" do
        expect(config.cache_path).to eq("/tmp/jekyll-assets")
      end
    end
  end

  context "#baseurl" do
    subject { config.baseurl }

    context "when given" do
      let(:options) { { :dirname => "foo", :baseurl => "/bar/" } }
      it { is_expected.to eq "/bar" }
    end

    context "when not explicitly given" do
      let(:options) { { :dirname => "foo" } }
      it { is_expected.to eq "/foo" }

      context "and site has baseurl config" do
        before { @site.config["baseurl"] = "/blog" }
        it { is_expected.to eq "/blog/foo" }
      end
    end
  end

  context "#js_compressor" do
    subject { config.js_compressor }

    context "when js compressor is given as `uglify`" do
      let(:options) { { :js_compressor => "uglify" } }
      it { is_expected.to be :uglify }
    end

    context "otherwise" do
      it { is_expected.to be_falsey }
    end
  end

  context "#css_compressor" do
    subject { config.css_compressor }

    context "when css compressor is given as `sass`" do
      let(:options) { { :css_compressor => "sass" } }
      it { is_expected.to be :sass }
    end

    context "otherwise" do
      it { is_expected.to be_falsey }
    end
  end

  context "#gzip" do
    subject { config.gzip }

    context "when gzip is disabled" do
      let(:options) { { :gzip => false } }
      it { is_expected.to eq [] }
    end
  end

  context "#version" do
    let(:options) { { :version => "abc" } }
    subject       { config.version }

    it { is_expected.to be options.fetch(:version) }
  end

  context "Deprecated options" do
    context "compress" do
      let :options do
        { :compress => { :js => "uglify", :css => "sass" } }
      end

      describe "#js_compressor" do
        subject { config.js_compressor }
        it { is_expected.to be :uglify }
      end

      describe "#css_compressor" do
        subject { config.css_compressor }
        it { is_expected.to be :sass }
      end
    end

    context "cache_assets" do
      let(:options) { { :cache_assets => true } }

      it "sets `cache` value" do
        expect(config.cache_assets?).to eq true
      end
    end
  end
end
