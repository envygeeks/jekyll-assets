require "spec_helper"


module Jekyll::AssetsPlugin
  describe Environment do
    context "#asset_path of context" do
      it "should properly handle query params" do
        css = @site.assets["vapor.css"].to_s
        css.should =~ %r{fonts/vapor-[a-f0-9]{32}\.eot\?#iefix}
        css.should =~ %r{fonts/vapor-[a-f0-9]{32}\.svg#iefix}
      end
    end
  end
end
