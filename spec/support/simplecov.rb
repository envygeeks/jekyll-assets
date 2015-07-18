require "envygeeks/coveralls"
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/vendor/"
end
