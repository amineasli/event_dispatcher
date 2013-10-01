require 'test/unit'
require 'event_dispatcher'

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
 
   def test_remove_listener
      @dispatcher.add_listener( :pre_foo, { object: @listener, method: 'PreFoo' }, 10)
      assert_equal true, @dispatcher.has_listeners?( PREFOO )
      @dispatcher.remove_listener( :pre_foo, { object: @listener , method: 'PreFoo' } ) 
      assert_equal false, @dispatcher.has_listeners?( PREFOO )
      @dispatcher.remove_listener( :not_exists, { object: @listener , method: 'PreFoo' } ) 
   end
  
   def test_dispatcher_for_object
      @dispatcher.add_listener( :pre_foo, { object: @listener, method: 'pre_foo_invoked!' } ) 
      @dispatcher.add_listener( :post_foo, { object: @listener, method: 'post_foo_invoked!' } )

      @foo_bar = TestFooBar.new( 'foo', 'bar' )
      @test_event = TestEvent.new( @foo_bar )

      @dispatcher.dispatch( :pre_foo, @test_event ) 
      assert_equal true, @listener.pre_foo_invoked
      assert_equal false, @listener.post_foo_invoked
      @dispatcher.dispatch( :post_foo, @test_event ) 
 
      assert_equal true, @listener.post_foo_invoked
   end
   
   def test_dispatcher_for_block
      invoked = 0
      block1 = lambda do |event|
         invoked += 1
      end

      @dispatcher.add_listener( :pre_foo, block1 ) 

      @foo_bar = TestFooBar.new( 'foo', 'bar' )
      @test_event = TestEvent.new( @foo_bar )

      @dispatcher.dispatch( :pre_foo, @test_event ) 
      assert_equal 1, invoked
   end
end

class TestEventListener

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

class TestFooBar
   attr_accessor :foo, :bar
  
   def initialize( foo, bar )
      @foo = foo 
      @bar = bar
   end

   def foo_bar
      @foo + '-' + @bar
   end
end

class TestEvent
   include EventDispatcher::Event
   attr_reader :foo_bar

   def initialize( foo_bar )
      @foo_bar = foo_bar
   end
end
