require 'test_helper'
class ExpectationTest < Minitest::Test
  include Less

  should "parameters hash can meet an expectation" do
    ex = Expectation.new(:name)
    params = {name: "Mike", age: 27}
    assert ex.verify(params)
  end

  should "parameters hash fails when not meeting an expectation" do
    ex = Expectation.new(:name)
    params = {name: nil, age: 27}
    refute ex.verify(params)
  end

  should "parameters hash fails if expectation is absent" do
    ex = Expectation.new(:name)
    params = {age: 27}
    refute ex.verify(params)
  end

end
