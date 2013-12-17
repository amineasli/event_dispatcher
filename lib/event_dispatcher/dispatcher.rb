module EventDispatcher
   class Dispatcher
      attr_reader :listeners

      def initialize
         @listeners = {}
      end

      # Checks if the given event has some listeners that want to listen to.
      def has_listeners?(event_name)
         event_name = symbolize_key(event_name) 
         @listeners.key?(event_name) && @listeners[event_name].size > 0  ? true : false
      end

      # Using Struct as data container for each listener.
      Listener = Struct.new(:listener, :priority)

      # Connects a listener to the dispatcher so that it can be notified when an event is dispatched.  
      def add_listener(event_name, listener, priority = 0)
         raise ArgumentError.new("Priority must be a Fixnum") unless priority.is_a?(Fixnum)
         event_name = symbolize_key(event_name) 
         @listeners[event_name] ||= []
         @listeners[event_name] << Listener.new(listener, priority)

         sort_listeners!(event_name)
      end

      alias_method :<<, :add_listener

      # Removes an event listener from the specified event.
      def remove_listener!(event_name, listener)
         event_name = symbolize_key(event_name) 
         return unless @listeners.key?(event_name) && !listener.nil?
         @listeners[event_name].delete_if { |l| l.listener.eql?(listener) }

         sort_listeners!(event_name)
      end
 
      # Removes a collection of event listeners from the specified event, or reset the entire container of listeners if no event is given. 
      def remove_listeners!(event_name = nil)
         if event_name.nil?
            @listeners.clear
         else 
             event_name = symbolize_key(event_name) 
             @listeners.delete(event_name) if @listeners.key?(event_name)
         end
      end

      # Notifies all listeners of the given event. The event instance is then passed to each listener of that event.
      def dispatch(event_name, event)
         event_name = symbolize_key(event_name) 
         return unless @listeners.key?(event_name) && !event.nil?
         @listeners[event_name].each do |l|
            invoke_callable(l.listener, event)  
            # A Listener is able to tell the dispatcher to stop all propagation of the event to future listeners.
            break if event.respond_to?(:stop_propagation) && event.stop_propagation 
         end
      end
      
      private 
         # For better performance we convert each string key into symbol one.
         def symbolize_key(key)
            key.to_sym rescue key
         end

         # Sorts the list of listeners attached to given event by priority. The higher the priority, the earlier the listener is called.
         def sort_listeners!(event_name)
            @listeners[event_name].sort_by! { |l| l.priority }
         end

         # Calls the listener instance method which is responsible of handling the event object.        
         def invoke_callable(callable, event)
            raise ArgumentError.new("Listener must be a block or a callable object's method") unless callable.respond_to?(:call)
            callable.call(event)   
         end
   end
end
