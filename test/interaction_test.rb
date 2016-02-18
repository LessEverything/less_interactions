require 'test_helper'
class InteractionTest < Minitest::Test
  include Less

  should "not be able to run an interaction without run defined" do
    class InteractionWithoutRun < Interaction; end
    assert_raises(InvalidInteractionError) { InteractionWithoutRun.run }
  end

  should "be able to run an interaction with run defined" do
    class InteractionWithRun < Interaction ; def run; end ; end
    assert_nothing_raised { InteractionWithRun.run }
  end

  should "run an interaction with an options hash" do
    class InteractionWithAHash < Interaction; def run; end; end
    assert_nothing_raised { InteractionWithAHash.run(:test => 3) }
  end

  should "call init when running an interaction" do
    class InteractionExpectingInit < Interaction; def run; end; end
    InteractionExpectingInit.any_instance.expects(:init)
    InteractionExpectingInit.run
  end

  should "call init when running an interaction with an init method" do
    class InteractionExpectingInit2 < Interaction
      expects :a, allow_nil: true
      def run; self; end
      def init; @a = 1; end
    end
    i = InteractionExpectingInit2.run
    assert_equal 1, i.instance_variable_get(:@a)
  end

  should "call the writer if there is one" do
    class InteractionWithWriter < Interaction
      expects :a, allow_nil: true
      def run; self; end
      def a= val; @a += 1; end
    end
    i = InteractionWithWriter.run a: 1
    assert_equal 2, i.instance_variable_get(:@a)
  end

  should "call the writer if there is one and value is not null" do
    class GobbledyGook; def gobble; "gook"; end; end
    class InteractionWithWriter < Interaction
      expects :a, allow_nil: true
      def run; self; end
      def a= val; @a = val.gobble; end
    end
    i = InteractionWithWriter.run
    i.a = GobbledyGook.new
    assert_equal "gook", i.instance_variable_get(:@a)
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
    assert_raises(MissingParameterError) { InteractionMissingParameter.run }
  end

  should "fail if an expected parameter is nil" do
    class InteractionWithNilParameter < Less::Interaction
      expects :title

      def run; end
    end
    assert_raises(MissingParameterError) { InteractionWithNilParameter.run(:title => nil) }
  end

  should "run if an expected parameter is found" do
    class InteractionWithParameter < Less::Interaction
      expects :title

      def run; end
    end
    assert_nothing_raised { InteractionWithParameter.run(:title => "Hello, test") }
  end

  should "run if an expected parameter is found, even if it is false" do
    class InteractionWithParameter < Less::Interaction
      expects :title

      def run; end
    end
    assert_nothing_raised { InteractionWithParameter.run(:title => false) }
  end

  should "run if an expected parameter is found, even if it is nil, if the option is specified" do
    class InteractionWithParameter < Less::Interaction
      expects :title, :allow_nil => true

      def run;end
    end
    assert_nothing_raised { InteractionWithParameter.run(:title => nil) }
  end

  should "run if an expected parameter is found, even if it is nil, if the option is not specified, but is allow_nil and is called" do
    class InteractionWithParameter < Less::Interaction
      expects :title, :allow_nil => true

      def run; title;end
    end
    assert_nothing_raised { InteractionWithParameter.run() }
  end

  should "set ivars from options on initialize" do
    i = Less::Interaction.new a: 1, b:2
    assert_equal 1, i.instance_variable_get(:@a)
    assert_equal 2, i.instance_variable_get(:@b)
  end


  should "Convert first param to context on initialize" do
    i = Less::Interaction.new 1, b:2
    assert_equal 1, i.instance_variable_get(:@context)
    assert_equal 2, i.instance_variable_get(:@b)
  end

  should "be able to fake out expects" do
    class FakeoutExpects < Less::Interaction
      expects :object
      def initialize params, options
        super :object => params[:object_id].to_s #or a finder or something instead of to_s
      end
      def run; self; end #return self just so I can test the value
    end
    assert_nothing_raised do
      x = FakeoutExpects.run( :object_id => 1)
      assert_equal "1", x.instance_variable_get(:@object)
    end
  end

  should "be able to override an expects" do

    class OverrideExpects < Less::Interaction
      expects :object, allow_nil: true

      def run; self; end #return self just so I can test the value
      def object; "YES!";  end
    end

    x = OverrideExpects.new(1, object: "no :(").run
    assert_equal "YES!", x.object
  end


  should "get a method that returns nil from an allow_nil expects" do

    class NilExpects < Less::Interaction
      expects :object, allow_nil: true
      def run; self; end #return self just so I can test the value
    end

    x = NilExpects.run
    assert_equal nil, x.object
  end

  should "be able to override an inherited expects" do
     class OverrideExpects < Less::Interaction
       expects :int

       def run; self; end #return self just so I can test the value
       private
       def int; @int.to_s;  end
     end
     class OverrideIt < OverrideExpects
       expects :int
     end

     x = OverrideIt.new(int: 1).run
     assert_equal "1", x.send(:int)
   end


   should "fail if all expects_any parameters are nil" do
     class AnyInteractionWithAllNilParameters < Less::Interaction
       expects_any :title, :a, :b
       def run; end
     end
     assert_raises(MissingParameterError) { AnyInteractionWithAllNilParameters.run() }
   end

   should "pass if any expects_any parameters is not nil" do
     class AnyInteractionWithOneNonNilParameter < Less::Interaction
       expects_any :title, :a, :b
       def run; true; end
     end
     assert AnyInteractionWithOneNonNilParameter.run(:b => 1)
   end

   should "call expectations_met? before init" do
     class ExpectationsMetBeforeInit < Less::Interaction
       expects :a
       expects_any :b, :c
       def init; raise "Called init first"; end
       def run; end
     end
     assert_raise(MissingParameterError) { ExpectationsMetBeforeInit.run() }
   end

end
