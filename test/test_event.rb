require 'test/unit'
require 'event_dispatcher'

class EventTest < Test::Unit::TestCase
   def setup
      @event = TestEventClass.new 
   end

   def test_if_propagation_stopped
      assert_equal false, @event.stop_propagation
   end

   def test_stop_propagation_and_if_propagation_stopped
      @event.stop_propagation = true
      assert_equal true, @event.stop_propagation
   end
end

class TestEventClass
   include EventDispatcher::Event
end
