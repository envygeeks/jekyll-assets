require "spec_helper"

module Jekyll::AssetsPlugin
  describe Tag do
    let(:context) { { :registers => { :site => @site } } }

    def render(content)
      Liquid::Template.parse(content).render({}, context)
    end

    context "{% image <file> %}" do
      def tag_re(name)
        file = "/assets/#{name}-[a-f0-9]{32}\.png"
        Regexp.new "^#{Renderer::IMAGE % file}$"
      end

      context "when <file> exists" do
        subject { render("{% image noise.png %}") }
        it { should match tag_re("noise") }
      end

      context "when <file> does not exists" do
        subject { render("{% image not-found.png %}") }
        it { should match "Liquid error: Couldn't find file 'not-found.png'" }
      end
    end

    context "{% stylesheet <file> %}" do
      def tag_re(name)
        file = "/assets/#{name}-[a-f0-9]{32}\.css"
        Regexp.new "^#{Renderer::STYLESHEET % file}$"
      end

      context "when <file> exists" do
        subject { render("{% stylesheet app.css %}") }
        it { should match tag_re("app") }
      end

      context "when <file> extension is omited" do
        subject { render("{% stylesheet app %}") }
        it { should match tag_re("app") }
      end

      context "when <file> does not exists" do
        subject { render("{% stylesheet not-found.css %}") }
        it { should match "Liquid error: Couldn't find file 'not-found.css'" }
      end
    end

    context "{% javascript <file> %}" do
      def tag_re(name)
        file = "/assets/#{name}-[a-f0-9]{32}\.js"
        Regexp.new "^#{Renderer::JAVASCRIPT % file}$"
      end

      context "when <file> exists" do
        subject { render("{% javascript app.js %}") }
        it { should match tag_re("app") }
      end

      context "when <file> extension omited" do
        subject { render("{% javascript app %}") }
        it { should match tag_re("app") }
      end

      context "when <file> does not exists" do
        subject { render("{% javascript not-found.js %}") }
        it { should match "Liquid error: Couldn't find file 'not-found.js'" }
      end
    end

    context "{% asset_path <file.ext> %}" do
      context "when <file> exists" do
        subject { render("{% asset_path app.css %}") }
        it { should match(%r{^/assets/app-[a-f0-9]{32}\.css$}) }
      end

      context "when <file> does not exists" do
        subject { render("{% asset_path not-found.js %}") }
        it { should match "Liquid error: Couldn't find file 'not-found.js'" }
      end

      context "with baseurl given as /foobar/" do
        before do
          context[:registers][:site].assets_config.baseurl = "/foobar/"
        end

        subject { render("{% asset_path app.css %}") }
        it { should match(%r{^/foobar/app-[a-f0-9]{32}\.css$}) }
      end
    end

    context "{% asset <file.ext> %}" do
      context "when <file> exists" do
        subject { render("{% asset app.css %}") }
        it { should match(/body \{ background-image: url\(.+?\) \}/) }
      end

      context "when <file> does not exists" do
        subject { render("{% asset_path not-found.js %}") }
        it { should match "Liquid error: Couldn't find file 'not-found.js'" }
      end
    end
  end
end
