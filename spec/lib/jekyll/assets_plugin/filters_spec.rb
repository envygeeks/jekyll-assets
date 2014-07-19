require "spec_helper"

RSpec.describe Jekyll::AssetsPlugin::Filters do
  let(:context) { { :registers => { :site => @site } } }

  def render(content)
    ::Liquid::Template.parse(content).render({}, context)
  end

  def not_found_error(file)
    "Liquid error: Couldn't find file '#{file}"
  end

  def render_tag(template, path, attrs = "")
    template = Jekyll::AssetsPlugin::Renderer.const_get template
    format template, :path => path, :attrs => attrs
  end

  context "{{ '<file>' | image }}" do
    def tag_re(name)
      file = "/assets/#{name}-[a-f0-9]{32}\.png"
      Regexp.new "^#{render_tag :IMAGE, file}$"
    end

    context "when <file> exists" do
      subject { render("{{ 'noise.png' | image }}") }
      it { is_expected.to match tag_re("noise") }
    end

    context "when <file> does not exists" do
      subject { render("{{ 'not-found.png' | image }}") }
      it { is_expected.to match not_found_error "not-found.png" }
    end
  end

  context "{{ '<file>' | stylesheet }}" do
    def tag_re(name)
      file = "/assets/#{name}-[a-f0-9]{32}\.css"
      Regexp.new "^#{render_tag :STYLESHEET, file}$"
    end

    context "when <file> exists" do
      subject { render("{{ 'app.css' | stylesheet }}") }
      it { is_expected.to match tag_re("app") }
    end

    context "when <file> extension is omited" do
      subject { render("{{ 'app' | stylesheet }}") }
      it { is_expected.to match tag_re("app") }
    end

    context "when <file> does not exists" do
      subject { render("{{ 'not-found.css' | stylesheet }}") }
      it { is_expected.to match not_found_error "not-found.css" }
    end
  end

  context "{{ '<file>' | javascript }}" do
    def tag_re(name)
      file = "/assets/#{name}-[a-f0-9]{32}\.js"
      Regexp.new "^#{render_tag :JAVASCRIPT, file}$"
    end

    context "when <file> exists" do
      subject { render("{{ 'app.js' | javascript }}") }
      it { is_expected.to match tag_re("app") }
    end

    context "when <file> extension omited" do
      subject { render("{{ 'app' | javascript }}") }
      it { is_expected.to match tag_re("app") }
    end

    context "when <file> does not exists" do
      subject { render("{{ 'not-found.js' | javascript }}") }
      it { is_expected.to match not_found_error "not-found.js" }
    end
  end

  context "{{ '<file.ext>' | asset_path }}" do
    context "when <file> exists" do
      subject { render("{{ 'app.css' | asset_path }}") }
      it { is_expected.to match(%r{^/assets/app-[a-f0-9]{32}\.css$}) }
    end

    context "when <file> does not exists" do
      subject { render("{{ 'not-found.css' | asset_path }}") }
      it { is_expected.to match not_found_error "not-found.css" }
    end

    context "with baseurl given as /foobar/" do
      before do
        context[:registers][:site].assets_config.baseurl = "/foobar/"
      end

      subject { render("{{ 'app.css' | asset_path }}") }
      it { is_expected.to match(%r{^/foobar/app-[a-f0-9]{32}\.css$}) }
    end
  end

  context "{{ '<file.ext>' | asset }}" do
    context "when <file> exists" do
      subject { render("{{ 'app.css' | asset }}") }
      it { is_expected.to match(/body \{ background-image: url\(.+?\) \}/) }
    end

    context "when <file> does not exists" do
      subject { render("{{ 'not-found.js' | asset }}") }
      it { is_expected.to match not_found_error "not-found.js" }
    end
  end
end
