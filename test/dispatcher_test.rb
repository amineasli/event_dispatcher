require 'test/unit'
require '../lib/dispatcher.rb'

class DispatcherTest < Test::Unit::TestCase
   PREFOO = :prefoo
   POSTFOO = :postfoo 

   def setup
      @dispatcher = EventDispatcher::Dispatcher.new
     # @listener = TestEventListener.new
   end

   def test_initial_state
      assert_empty @dispatcher.get_listeners
      assert_equal false, @dispatcher.has_listeners?( PREFOO ) 
      assert_equal false, @dispatcher.has_listeners?( POSTFOO ) 
   end

   def test_add_listener
      @dispatcher.add_listener( :prefoo, { object: @listener, method: 'PreFoo' } )
      @dispatcher.add_listener( :postfoo, { object: @listener, method: 'PostFoo' } )
      assert_equal true, @dispatcher.has_listeners?( PREFOO )
      assert_equal true, @dispatcher.has_listeners?( POSTFOO )
   end
end



