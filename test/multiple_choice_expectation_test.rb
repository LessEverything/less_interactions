require 'test_helper'
class MultipleChoiceExpectation < Minitest::Test
  include Less

  should "parameters hash can meet an expectation" do
    ex = MultipleChoiceExpectation.new([:name, :user, :id])
    params = {name: "Mike"}
    assert_nothing_raised do
      ex.verify(params)
    end
  end

  should "parameters hash fails if all parameters are nil" do
    ex = MultipleChoiceExpectation.new([:name, :user, :id])
    params = {name: nil, age: nil}
    assert_raises (MissingParameterError) do
      ex.verify(params)
    end
  end

  should "parameters hash should pass when one parameter is not nil" do 
    ex = MultipleChoiceExpectation.new([:name, :age, :id])
    params = {name: nil, age: 55}
    assert_nothing_raised do 
      ex.verify(params)
    end
  end

  should "parameters hash should pass even if some parameters are missing" do 
    ex = MultipleChoiceExpectation.new([:name, :age, :id])
    params = {name: "Michael"}
    assert_nothing_raised do 
      ex.verify(params)
    end
  end

  should "parameters hash should fail if no parameters are passed in" do 
    ex = MultipleChoiceExpectation.new([:name, :age, :id])
    params = {}
    assert_raises (MissingParameterError) do 
      ex.verify(params)
    end
  end

end
