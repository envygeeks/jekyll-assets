require "spec_helper"

describe Jekyll::AssetsPlugin::Configuration do
  context "with defaults" do
    let(:config) { described_class.new }

    context "output assets dirname" do
      subject { config.dirname }
      it { should == described_class::DEFAULTS[:dirname] }
    end

    context "assets baseurl" do
      subject { config.baseurl }
      it { should == "/" + described_class::DEFAULTS[:dirname] }
    end

    context "sources list" do
      subject { config.sources }
      it { should =~ described_class::DEFAULTS[:sources] }
    end

    context "cachebust" do
      subject { config.cachebust }
      it { should == :hard }
    end

    context "js compressor" do
      subject { config.js_compressor }
      it { should be_nil }
    end

    context "css compressor" do
      subject { config.css_compressor }
      it { should be_nil }
    end

    context "gzip" do
      subject { config.gzip }
      it { should =~ %w[text/css application/javascript] }
    end

    context "cache_assets?" do
      subject { config.cache_assets? }
      it { should be_false }
    end

    context "cache_path" do
      subject { config.cache_path }
      it { should == ".jekyll-assets-cache" }
    end

    context "debug" do
      subject { config.debug }
      it { should be_false }
    end

  end

  it "should override specified options and leave defaults for missing" do
    config = described_class.new({
      :sources        => %w[abc],
      :css_compressor => "sass"
    })

    expect(config.dirname).to eq "assets"
    expect(config.sources).to eq %w[abc]
    expect(config.js_compressor).to be_nil
    expect(config.css_compressor).to be  :sass
  end

  context "#cache" do
    context "when specified as String" do
      it "should override default cache path" do
        config = described_class.new :cache => "/tmp/jekyll-assets"
        expect(config.cache_path).to eq("/tmp/jekyll-assets")
      end
    end
  end

  context "#baseurl" do
    it "should respect explicit overrides" do
      expect(described_class.new({
        :dirname => "foo",
        :baseurl => "/bar/"
      }).baseurl).to eq("/bar")
    end

    it "should be auto-guessed from dirname" do
      expect(described_class.new({
        :dirname => "foo"
      }).baseurl).to eq("/foo")
    end
  end

  context "#js_compressor" do
    context "when js compressor is given as `uglify`" do
      let(:config) { described_class.new(:js_compressor => "uglify") }
      subject { config.js_compressor }
      it { should be :uglify }
    end

    context "otherwise" do
      let(:config) { described_class.new }
      subject { config.js_compressor }
      it { should be_false }
    end
  end

  context "#css_compressor" do
    context "when css compressor is given as `sass`" do
      let(:config) { described_class.new(:css_compressor => "sass") }
      subject { config.css_compressor }
      it { should be :sass }
    end

    context "otherwise" do
      let(:config) { described_class.new }
      subject { config.css_compressor }
      it { should be_false }
    end
  end

  context "#gzip" do
    context "when gzip is disabled" do
      let(:config) { described_class.new(:gzip => false) }
      subject { config.gzip }
      it { should == [] }
    end
  end

  context "#version" do
    subject { described_class.new(:version => version).version }

    context "when given as 123" do
      let(:version) { 123 }
      it { should eq 123 }
      it { should be_a Integer }
    end

    context "when given as 'abc'" do
      let(:version) { "abc" }
      it { should eq "abc" }
      it { should be_a String }
    end
  end

  context "Deprecated options" do
    subject(:config) { described_class.new options }

    context "compress" do
      let :options do
        { :compress => { :js => "uglify", :css => "sass" } }
      end

      describe '#js_compressor' do
        subject { super().js_compressor }
        it { should be :uglify }
      end

      describe '#css_compressor' do
        subject { super().css_compressor }
        it { should be :sass }
      end
    end

    context "cache_assets" do
      let(:options) { { :cache_assets => true } }

      it "should set `cache` value" do
        expect(config.cache_assets?).to be_true
      end
    end
  end
end
