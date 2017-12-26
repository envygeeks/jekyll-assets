# Frozen-string-literal: true
# Copyright: 2012 - 2017 - MIT License
# Encoding: utf-8

# --
# 🔖
# RSpec, MiniTest, Whatever.
# --
task :spec do
  exec "script/test"
end
# --
# 🔖
# RSpec, MiniTest, Whatever.
# --
task :test do
  exec "script/test"
end
# --
# 🔖
# @see .rubocop.yml
# Rubocop.
# --
task :rubocop do
  exec "script/lint"
end
# --
# 🔖
# @see .rubocop.yml
# Rubocop.
# --
task :lint do
  exec "script/lint"
end

# --
Dir.glob("script/rake.d/*.rake").each do |v|
  load v
end
