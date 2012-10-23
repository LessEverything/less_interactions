require 'test_helper'

class X < Less::Interaction
  def run
    Less::Response.new 876, [1,2]
  end
end

class ResponseTest < Test::Unit::TestCase
  include Less

  
  should "be able to fake out expects" do
    assert_nothing_raised do
      x = X.run
      assert_equal 876, x.status
      assert_equal [1,2], x.object
    end
  end
  
end
