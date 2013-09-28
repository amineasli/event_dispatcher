module EventDispatcher
   class Dispatcher
      attr_accessor :listeners
      def initialize
         @listeners = {}
         @sorted = {}
      end
     
      def get_listeners( event_name = nil )
         if event_name
            sort_listeners!( event_name )  if @sorted[event_name].nil?

            return @sorted[event_name]
         end   

         @listeners.each_key { |event_name| sort_listeners!( event_name ) if @sorted[event_name].nil?  }

         return @sorted
      end

      def has_listeners?( event_name = nil )
          get_listeners( event_name ).count > 0 ? true : false
      end

      def add_listener( event_name, listener, priority = 0 )
         @listeners[event_name] ||= {}
         @listeners[event_name][priority] ||= [] 
         @listeners[event_name][priority].push(listener)
         @sorted[event_name].clear unless @sorted[event_name].nil?
      end
    
      def sort_listeners!( event_name )
         @sorted[event_name] = [] 
         
         if @listeners[event_name]
            @sorted[event_name] = @listeners[event_name].sort
         end
      end
   end
end
