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
  
  should "be successful" do
    x = Less::Response.new 200, []
    assert x.success?
    assert_equal false, x.error?
    assert_equal false, x.client_error?
    assert_equal false, x.server_error?
    x.status = 201
    assert x.success?
    assert_equal false, x.error?
    assert_equal false, x.client_error?
    assert_equal false, x.server_error?
  end
  
  should "be client_error" do
    x = Less::Response.new 400, []
    assert x.error?
    assert x.client_error?
    assert_equal false, x.server_error?
    assert_equal false, x.success?
    x.status = 422
    assert x.error?
    assert x.client_error?
    assert_equal false, x.server_error?
    assert_equal false, x.success?
  end
  
  should "be server_error" do
    x = Less::Response.new 500, []
    assert x.error?
    assert x.server_error?
    assert_equal false, x.client_error?
    assert_equal false, x.success?
    x.status = 501
    assert x.error?
    assert x.server_error?
    assert_equal false, x.client_error?
    assert_equal false, x.success?
  end
  
end
