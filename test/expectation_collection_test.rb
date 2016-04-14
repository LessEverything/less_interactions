require 'test_helper'
class ExpectationCollectionTest < Minitest::Test
  include Less

  should "parameters hash can meet an expectation" do
    ex = ExpectationCollection.new(:name, :user, :id)
    params = {name: "Mike"}
    assert_nothing_raised do
      ex.verify(params)
    end
  end

  should "parameters hash fails if all parameters are nil" do
    ex = ExpectationCollection.new(:name, :user, :id)
    params = {name: nil, age: nil}
    assert_raises (MissingParameterError) do
      ex.verify(params)
    end

  end
end
