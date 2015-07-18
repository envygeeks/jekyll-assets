require "rspec/helper"

describe Jekyll::Assets::Hook do
  context :register do
    it "adds the hook" do
      Jekyll::Assets::Hook.register(:env, :pre_init, &proc {})
      expect(Jekyll::Assets::Hook.hooks[:env][:pre_init].size).to eq(
        1
      )
    end

    it "raises if there is no hook base" do
      expect { Jekyll::Assets::Hook.register(:unknown, :unknown, &proc {}) }.to(
        raise_error(
          Jekyll::Assets::Hook::UnknownHookError
        )
      )
    end

    it "raises if there is no hook point" do
      expect { Jekyll::Assets::Hook.register(:env, :unknown, &proc {}) }.to(
        raise_error(
          Jekyll::Assets::Hook::UnknownHookError
        )
      )
    end
  end

  context :trigger_hooks do
    it "calls hooks" do
      a = 1; Jekyll::Assets::Hook.register(:env, :pre_init, &proc { a = 2 })
      Jekyll::Assets::Hook.trigger(:env, :pre_init)
      expect(a).to eq(
        2
      )
    end
  end
end
