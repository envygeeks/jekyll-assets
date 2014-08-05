require "spec_helper"

RSpec.describe Jekyll::AssetsPlugin::Tag do
  let(:context) { { :registers => { :site => @site } } }

  def render(content)
    ::Liquid::Template.parse(content).render({}, context)
  end

  def not_found_error(file)
    "Liquid error: Couldn't find file '#{file}'"
  end

  def render_tag(template, path, attrs = "")
    template  = Jekyll::AssetsPlugin::Renderer.const_get template
    attrs     = " #{attrs}" unless attrs.empty?

    format template, :path => path, :attrs => attrs
  end

  context "{% image <file> %}" do
    def tag_re(name, attrs = "")
      file = "/assets/#{name}-[a-f0-9]{32}\.png"
      Regexp.new "^#{render_tag :IMAGE, file, attrs}$"
    end

    context "when <file> exists" do
      subject { render("{% image noise.png %}") }
      it { is_expected.to match tag_re("noise") }
    end

    context "when <file> has an attribute" do
      subject { render("{% image noise.png alt=\"Foobar\" %}") }
      it { is_expected.to match tag_re("noise", "alt=\"Foobar\"") }
    end

    context "when <file> does not exists" do
      subject { render("{% image not-found.png %}") }
      it { is_expected.to match not_found_error "not-found.png" }
    end
  end

  context "{% stylesheet <file> %}" do
    def tag_re(name, attrs = "")
      file = "/assets/#{name}-[a-f0-9]{32}\.css"
      Regexp.new "^#{render_tag :STYLESHEET, file, attrs}$"
    end

    context "when <file> exists" do
      subject { render("{% stylesheet app.css %}") }
      it { is_expected.to match tag_re("app") }
    end

    context "when <file> has an attribute" do
      subject { render("{% stylesheet app.css type=\"text/css\" %}") }
      it { is_expected.to match tag_re("app", "type=\"text/css\"") }
    end

    context "when <file> name has multiple dots" do
      subject { render("{% stylesheet app.min %}") }
      it { is_expected.to match tag_re("app.min") }
    end

    context "when <file> extension is omited" do
      subject { render("{% stylesheet app %}") }
      it { is_expected.to match tag_re("app") }
    end

    context "when <file> does not exists" do
      subject { render("{% stylesheet not-found.css %}") }
      it { is_expected.to match not_found_error "not-found.css" }
    end
  end

  context "{% javascript <file> %}" do
    def tag_re(name, attrs = "")
      file = "/assets/#{name}-[a-f0-9]{32}\.js"
      Regexp.new "^#{render_tag :JAVASCRIPT, file, attrs}$"
    end

    context "when <file> exists" do
      subject { render("{% javascript app.js %}") }
      it { is_expected.to match tag_re("app") }
    end

    context "when <file> has an attribute" do
      subject { render("{% javascript app.js type=\"text/javascript\" %}") }
      it { is_expected.to match tag_re("app", "type=\"text/javascript\"") }
    end

    context "when <file> name has multiple dots" do
      subject { render("{% javascript app.min %}") }
      it { is_expected.to match tag_re("app.min") }
    end

    context "when <file> extension omited" do
      subject { render("{% javascript app %}") }
      it { is_expected.to match tag_re("app") }
    end

    context "when <file> does not exists" do
      subject { render("{% javascript not-found.js %}") }
      it { is_expected.to match not_found_error "not-found.js" }
    end
  end

  context "{% asset_path <file.ext> %}" do
    context "when <file> exists" do
      subject { render("{% asset_path app.css %}") }
      it { is_expected.to match(%r{^/assets/app-[a-f0-9]{32}\.css$}) }
    end

    context "when <file> does not exists" do
      subject { render("{% asset_path not-found.js %}") }
      it { is_expected.to match not_found_error "not-found.js" }
    end

    context "with baseurl given as /foobar/" do
      before do
        context[:registers][:site].assets_config.baseurl = "/foobar/"
      end

      subject { render("{% asset_path app.css %}") }
      it { is_expected.to match(%r{^/foobar/app-[a-f0-9]{32}\.css$}) }
    end
  end

  context "{% asset <file.ext> %}" do
    context "when <file> exists" do
      subject { render("{% asset app.css %}") }
      it { is_expected.to match(/body \{ background-image: url\(.+?\) \}/) }
    end

    context "when <file> does not exists" do
      subject { render("{% asset_path not-found.js %}") }
      it { is_expected.to match not_found_error "not-found.js" }
    end
  end
end
