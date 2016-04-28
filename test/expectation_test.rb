require 'test_helper'
class ExpectationTest < Minitest::Test
  include Less

  should "parameters hash can meet an expectation" do
    ex = Expectation.new(:name)
    params = {name: "Mike", age: 27}
    assert_nothing_raised do
      ex.verify(params)
    end
  end

  should "parameters hash fails when not meeting an expectation" do
    ex = Expectation.new(:name)
    params = {name: nil, age: 27}
    assert_raises(MissingParameterError) do
      ex.verify(params)
    end
  end

  should "parameters hash fails if expectation is absent" do
    ex = Expectation.new(:name)
    params = {age: 27}
    assert_raises(MissingParameterError) do
      ex.verify(params)
    end
  end

  should "parameters should not fail if allow nil is true parameters value is nil" do
    ex = Expectation.new(:name, allow_nil: true)
    params = {name: nil}
    assert_nothing_raised do
      ex.verify(params)
    end
  end

  should "parameters should not fail if allow nil is true and no parameters are passed" do
    ex = Expectation.new(:name, allow_nil: true)
    params = {}
    assert_nothing_raised do
      ex.verify(params)
    end
  end
end
