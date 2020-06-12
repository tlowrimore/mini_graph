$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "mini_graph"
require "minitest/autorun"
require "minitest/pride"

Minitest::PrideIO.pride!

# Macro for making test definitions easier to type and read.
def test(description, &block)
  unless block_given?
    raise ArgumentError, "`test` requires a block."
  end

  method_name = description.to_s.downcase.gsub(/\W+/, '_')

  if method_name.nil? || method_name.empty?
    raise ArgumentError, "`#{description}` is an invalid test description"
  end

  define_method("test_#{method_name}", &block)
end
