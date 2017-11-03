Jekyll::Hooks.register [:pages, :documents, :posts], :pre_render do |_, p|
  p["hello"] = {
    "world" => "img.png"
  }
end
