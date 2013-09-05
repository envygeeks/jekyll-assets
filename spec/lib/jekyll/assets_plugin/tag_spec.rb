require "spec_helper"


module Jekyll::AssetsPlugin
  describe Tag do
    let(:context) { { :registers => { :site => @site } } }

    def render content
      Liquid::Template.parse(content).render({}, context)
    end

    context "{% stylesheet <file> %}" do
      def tag_re name
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

      context "with a host specified" do
        before { context[:registers][:site].assets_config.host = "http://www.google.com" }

        # NOTE: We need to explicitly unset this since we can't guarantee the
        # order in which tests execute.
        before { ENV.delete('SKIP_ASSET_HOST') }

        subject { render("{% stylesheet app.css %}") }
        it { should include "http://www.google.com" }
      end

      context "with the host killswitch set" do
        before { context[:registers][:site].assets_config.host = "http://www.google.com" }
        before { ENV['SKIP_ASSET_HOST'] = '1' }
        subject { render("{% stylesheet app.css %}") }
        it { should_not include "http://www.google.com" }
      end
    end

    context "{% javascript <file> %}" do
      def tag_re name
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

      context "with a host specified" do
        before { context[:registers][:site].assets_config.host = "http://www.google.com" }

        # See note above.
        before { ENV.delete('SKIP_ASSET_HOST') }

        subject { render("{% javascript app.css %}") }
        it { should include "http://www.google.com" }
      end

      context "with the host killswitch set" do
        before { context[:registers][:site].assets_config.host = "http://www.google.com" }
        before { ENV['SKIP_ASSET_HOST'] = '1' }
        subject { render("{% javascript app.css %}") }
        it { should_not include "http://www.google.com" }
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
        before { context[:registers][:site].assets_config.baseurl = "/foobar/" }
        subject { render("{% asset_path app.css %}") }
        it { should match(%r{^/foobar/app-[a-f0-9]{32}\.css$}) }
      end

      context "with a host specified" do
        before { context[:registers][:site].assets_config.host = "http://www.google.com" }

        # See note above.
        before { ENV.delete('SKIP_ASSET_HOST') }

        subject { render("{% asset_path app.css %}") }
        it { should start_with "http://www.google.com" }
      end

      context "with the host killswitch set" do
        before { context[:registers][:site].assets_config.host = "http://www.google.com" }
        before { ENV['SKIP_ASSET_HOST'] = '1' }
        subject { render("{% javascript app.css %}") }
        it { should_not start_with "http://www.google.com" }
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
