$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "mini_graph"
require "minitest/autorun"
require "minitest/pride"

Minitest::PrideIO.pride!

# Macro for making test definitions easier to type and read.
def test(name, &block)
  test_name = "test_#{name.gsub(/\s+/, '_')}".to_sym
  defined   = method_defined? test_name

  raise "#{test_name} is already defined in #{self}" if defined
  
  if block_given?
    define_method(test_name, &block)
  else
    define_method(test_name) do
      flunk "No implementation provided for #{name}"
    end
  end
end