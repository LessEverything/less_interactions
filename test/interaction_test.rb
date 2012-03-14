require 'test_helper'
class InteractionTest < Test::Unit::TestCase
  include Less

  should "not be able to run an interaction without run defined" do
    class InteractionWithoutRun < Interaction; end
    assert_raise(InvalidInteractionError) { InteractionWithoutRun.run }
  end

  should "not be able to run an interaction with something that isn't an options hash" do
    class InteractionWithSomethingElse < Interaction; def run; end; end
    assert_raise(InvalidInteractionError) { InteractionWithSomethingElse.run('a') }
  end

  should "be able to run an interaction with run defined" do
    class InteractionWithRun < Interaction ; def run; end ; end
    assert_nothing_raised { InteractionWithRun.run }
  end

  should "run an interaction with an options hash" do
    class InteractionWithAHash < Interaction; def run; end; end
    assert_nothing_raised { InteractionWithAHash.run(:test => 3) }
  end

  should "call the run instance method when running an interaction" do
    class InteractionExpectingRun < Interaction; end
    InteractionExpectingRun.any_instance.expects(:run)
    InteractionExpectingRun.run
  end
end
