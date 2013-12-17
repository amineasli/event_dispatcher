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
      assert_empty @dispatcher.listeners

      assert_equal false, @dispatcher.has_listeners?(PREFOO) 
      assert_equal false, @dispatcher.has_listeners?(POSTFOO) 
   end
 
   def test_add_listener
      @dispatcher.add_listener(:pre_foo, @listener)
      @dispatcher.add_listener(:post_foo, @listener)

      assert_equal true, @dispatcher.has_listeners?(PREFOO)
      assert_equal true, @dispatcher.has_listeners?(POSTFOO)
      assert_equal 1, @dispatcher.listeners[PREFOO].size
      assert_equal 1, @dispatcher.listeners[PREFOO].size
      assert_equal 2, @dispatcher.listeners.size
   end
   
   def test_remove_listeners
      @dispatcher.add_listener(PREFOO, @listener)
      @dispatcher.add_listener(POSTFOO, @listener)
      @dispatcher.remove_listeners!(PREFOO)

      assert_equal false, @dispatcher.has_listeners?(PREFOO)
      assert_equal true, @dispatcher.has_listeners?(POSTFOO)
      assert_equal 1, @dispatcher.listeners.size
      
      @dispatcher.remove_listeners!

      assert_empty @dispatcher.listeners
   end

   def test_remove_listener!
      listener1 = TestEventListener.new       
      listener2 = TestEventListener.new       
      listener3 = TestEventListener.new 

      @dispatcher.add_listener(:pre_foo, listener1)
      @dispatcher.add_listener(:pre_foo, listener2)
      @dispatcher.add_listener(:pre_foo, listener3)

      assert_equal true, @dispatcher.has_listeners?(PREFOO)
      assert_equal 3, @dispatcher.listeners[PREFOO].size

      @dispatcher.remove_listener!(:pre_foo, listener1) 
      @dispatcher.remove_listener!(:pre_foo, listener2) 

      assert_equal true, @dispatcher.has_listeners?(PREFOO)
      assert_equal 1, @dispatcher.listeners.size
 
      @dispatcher.remove_listener!(:not_exists, listener3) 

      assert_equal true, @dispatcher.has_listeners?(PREFOO)
      assert_equal 1, @dispatcher.listeners.size
   end
 
   def test_listener_sorts_by_priority
      listener1 = TestEventListener.new       
      listener2 = TestEventListener.new       
      listener3 = TestEventListener.new       
      listener4 = TestEventListener.new       
      listener5 = TestEventListener.new       

      @dispatcher.add_listener(:pre_foo, listener1, 0)
      @dispatcher.add_listener(:pre_foo, listener2, -10)
      @dispatcher.add_listener(:pre_foo, listener3, 10)
      @dispatcher.add_listener(:post_foo, listener4)
      @dispatcher.add_listener(:post_foo, listener5, 10)

      assert_equal [:pre_foo, :post_foo], @dispatcher.listeners.keys 
      @dispatcher.listeners

      assert_equal true,  @dispatcher.listeners[PREFOO].first.include?(-10)
      assert_equal true,  @dispatcher.listeners[PREFOO].last.include?(10)
      assert_equal true,  @dispatcher.listeners[PREFOO][1].include?(0)
      assert_equal true,  @dispatcher.listeners[POSTFOO].first.include?(0)
      assert_equal true,  @dispatcher.listeners[POSTFOO].last.include?(10)
  end
  
  def test_dispatcher_for_block
      invoked = 0
      foo = '
'
      block1 = lambda do |event|
         invoked += 1
         foo = event.foo
      end

      @dispatcher.add_listener(:pre_foo, block1) 
      test_event = FooEvent.new
      @dispatcher.dispatch(:pre_foo, test_event) 

      assert_equal 1, invoked
      assert_equal 'foo', foo
  end
   
  def test_dispatcher_for_class
      
      assert_equal 'bar', @listener.bar
      test_event = FooEvent.new
      @dispatcher.add_listener(:pre_foo, @listener.method(:handle))
      @dispatcher.dispatch(:pre_foo, test_event)

      assert_equal 'foo', @listener.bar
  end

  def test_stop_event_propagation
      other_listener = TestEventListener.new
      test_event = FooEvent.new
      @dispatcher.add_listener(:pre_foo, @listener.method(:handle),10)
      @dispatcher.add_listener(:pre_foo, other_listener.method(:handle))
      @dispatcher.dispatch(:pre_foo, test_event)

      assert_equal 'foo', other_listener.bar
      assert_equal 'bar', @listener.bar
  end
   
end

class TestEventListener

   attr_accessor :bar

   def initialize
      @bar = 'bar'
   end

   def handle(event)
      @bar = event.foo
      event.stop_propagation = true
   end
end

class FooEvent
   include EventDispatcher::Event
   attr_accessor :foo

   def initialize
      @foo = 'foo'
   end
end

