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

  should "fail if an expected parameter is not found" do
    class InteractionMissingParameter < Less::Interaction
      expects :title

      def run; end
    end
    assert_raise(MissingParameterError) { InteractionMissingParameter.run }
  end

  should "fail if an expected parameter is nil" do
    class InteractionWithNilParameter < Less::Interaction
      expects :title

      def run; end
    end
    assert_raise(MissingParameterError) { InteractionWithNilParameter.run(:title => nil) }
  end

  should "run if an expected parameter is found" do
    class InteractionWithParameter < Less::Interaction
      expects :title

      def run; end
    end
    assert_nothing_raised { InteractionWithParameter.run(:title => "Hello, test") }
  end

  should "run if an expected parameter is found, even if it is nil, if the option is specified" do
    class InteractionWithParameter < Less::Interaction
      expects :title, :allow_nil => true

      def run; end
    end
    assert_nothing_raised { InteractionWithParameter.run(:title => nil) }
  end
  
  should "set ivars from options on initialize" do
    i = Less::Interaction.new a: 1, b:2
    assert_equal 1, i.instance_variable_get(:@a)
    assert_equal 2, i.instance_variable_get(:@b)
  end
  
  should "be able to fake out expects" do
    class X < Less::Interaction
      expects :object
      def initialize params
        super :object => params[:object_id].to_s #or a finder or something instead of to_s
      end
      def run; self; end #return self just so I can test the value
    end
    assert_nothing_raised do
      x = X.run( :object_id => 1)
      assert_equal "1", x.instance_variable_get(:@object)
    end
  end
  
end
