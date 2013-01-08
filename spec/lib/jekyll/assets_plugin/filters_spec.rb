require "spec_helper"


module Jekyll::AssetsPlugin
  describe Filters do
    let(:context) { { :registers => { :site => @site } } }

    def render content
      Liquid::Template.parse(content).render({}, context)
    end

    context "{{ '<file>' | stylesheet }}" do
      def tag_re name
        file = "/assets/#{name}-[a-f0-9]{32}\.css"
        Regexp.new "^#{Tag::STYLESHEET % file}$"
      end

      context "when <file> exists" do
        subject { render("{{ 'app.css' | stylesheet }}") }
        it { should match tag_re("app") }
      end

      context "when <file> extension is omited" do
        subject { render("{{ 'app' | stylesheet }}") }
        it { should match tag_re("app") }
      end

      context "when <file> does not exists" do
        subject { render("{{ 'not-found.css' | stylesheet }}") }
        it { should match "Liquid error: couldn't find file 'not-found.css'" }
      end
    end

    context "{{ '<file>' | javascript }}" do
      def tag_re name
        file = "/assets/#{name}-[a-f0-9]{32}\.js"
        Regexp.new "^#{Tag::JAVASCRIPT % file}$"
      end

      context "when <file> exists" do
        subject { render("{{ 'app.js' | javascript }}") }
        it { should match tag_re("app") }
      end

      context "when <file> extension omited" do
        subject { render("{{ 'app' | javascript }}") }
        it { should match tag_re("app") }
      end

      context "when <file> does not exists" do
        subject { render("{{ 'not-found.js' | javascript }}") }
        it { should match "Liquid error: couldn't find file 'not-found.js'" }
      end
    end

    context "{{ '<file.ext>' | asset_path }}" do
      context "when <file> exists" do
        subject { render("{{ 'app.css' | asset_path }}") }
        it { should match(%r{^/assets/app-[a-f0-9]{32}\.css$}) }
      end

      context "when <file> does not exists" do
        subject { render("{{ 'not-found.css' | asset_path }}") }
        it { should match "Liquid error: couldn't find file 'not-found.css'" }
      end

      context "with baseurl given as /foobar/" do
        before { context[:registers][:site].assets_config.baseurl = "/foobar/" }
        subject { render("{{ 'app.css' | asset_path }}") }
        it { should match(%r{^/foobar/app-[a-f0-9]{32}\.css$}) }
      end
    end

    context "{{ '<file.ext>' | asset }}" do
      context "when <file> exists" do
        subject { render("{{ 'app.css' | asset }}") }
        it { should match(/body \{ background-image: url\(.+?\) \}/) }
      end

      context "when <file> does not exists" do
        subject { render("{{ 'not-found.js' | asset }}") }
        it { should match "Liquid error: couldn't find file 'not-found.js'" }
      end
    end
  end
end
