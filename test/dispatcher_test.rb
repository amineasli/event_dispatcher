require 'test/unit'
require '../lib/dispatcher.rb'
require '../lib/event.rb'

class DispatcherTest < Test::Unit::TestCase
   PREFOO = :pre_foo
   POSTFOO = :post_foo 

   def setup
      @dispatcher = EventDispatcher::Dispatcher.new
      @listener = TestEventListener.new
   end

   def test_initial_state
      assert_empty @dispatcher.get_listeners
      assert_equal false, @dispatcher.has_listeners?( PREFOO ) 
      assert_equal false, @dispatcher.has_listeners?( POSTFOO ) 
   end

   def test_add_listener
      @dispatcher.add_listener( :pre_foo, { object: @listener, method: 'PreFoo' } )
      @dispatcher.add_listener( :post_foo, { object: @listener, method: 'PostFoo' } )
      assert_equal true, @dispatcher.has_listeners?( PREFOO )
      assert_equal true, @dispatcher.has_listeners?( POSTFOO )
      assert_equal 1, @dispatcher.get_listeners( PREFOO ).length
      assert_equal 1, @dispatcher.get_listeners( POSTFOO ).length
      assert_equal 2, @dispatcher.get_listeners.length
   end

   def test_listener_sorts_by_priority
      listener1 = TestEventListener.new       
      listener2 = TestEventListener.new       
      listener3 = TestEventListener.new       
      listener4 = TestEventListener.new       
      listener5 = TestEventListener.new       
      listener6 = TestEventListener.new       

      @dispatcher.add_listener( :pre_foo, { object: listener1, method: 'pre_foo_invoked!' }, 10)
      @dispatcher.add_listener( :pre_foo, { object: listener2, method: 'pre_foo_invoked!' })
      @dispatcher.add_listener( :pre_foo, { object: listener3, method: 'pre_foo_invoked!' }, -10)

      @dispatcher.add_listener( :post_foo, { object: listener4, method: 'post_foo_invoked!' }, -10)
      @dispatcher.add_listener( :post_foo, { object: listener5, method: 'post_foo_invoked!' } )
      @dispatcher.add_listener( :post_foo, { object: listener6, method: 'post_foo_invoked!' }, 10)

      assert_equal [:pre_foo, :post_foo], @dispatcher.get_listeners.keys 

      assert_equal true,  @dispatcher.get_listeners( :pre_foo )[0].include?( -10 )
      assert_equal true,  @dispatcher.get_listeners( :pre_foo )[1].include?( 0 )
      assert_equal true,  @dispatcher.get_listeners( :pre_foo )[2].include?( 10 )

      assert_equal true,  @dispatcher.get_listeners( :post_foo )[0].include?( -10 )
      assert_equal true,  @dispatcher.get_listeners( :post_foo )[1].include?( 0 )
      assert_equal true,  @dispatcher.get_listeners( :post_foo )[2].include?( 10 )

     
   end
end

class TestEventListener
   include EventDispatcher::Event

   attr_reader :pre_foo_invoked, :post_foo_invoked

   def initialize
      @pre_foo_invoked = false
      @post_foo_invoked = false
   end

   def pre_foo_invoked!( event )
      @pre_foo_invoked = true
   end

   def post_foo_invoked!( event )
      @post_foo_invoked = true
      event.stop_propagation
   end
end


