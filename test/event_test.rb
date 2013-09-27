require 'test/unit'
require '../lib/event.rb'

class EventTest < Test::Unit::TestCase
   def setup
      @event = TestEventClass.new 
   end

   def test_is_propagation_stopped
      assert_equal false, @event.propagation_stopped?
   end

   def test_stop_propagation_and_is_propagation_stopped
      @event.stop_propagation
      assert_equal true, @event.propagation_stopped?
   end
end

class TestEventClass
   include EventDispatcher::Event
end
