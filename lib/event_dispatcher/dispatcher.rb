module EventDispatcher
   class Dispatcher
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
       
      def remove_listener( event_name, listener )
         return if @listeners[event_name].nil?

         @listeners[event_name].each_pair do |priority, listeners|
           listeners.delete_if { |item| p listener == item  }
         end

         @sorted[event_name].clear unless @sorted[event_name].nil?
      end
    
      def dispatch( event_name, event = nil )
         return if @listeners[event_name].nil? || event.nil?
         
         do_dispatch( get_listeners( event_name ), event )
  
      end
      
      private 
    
         def sort_listeners!( event_name )
            @sorted[event_name] = {} 
            
            if @listeners[event_name]
               @sorted[event_name] = @listeners[event_name].sort
               
            end
         end
      
         def do_dispatch( listeners, event )
            listeners.each do |priority|
               priority[1].each do |listener|
                  if listener.is_a?(Hash) 
                     listener[:object].send( listener[:method], event  )
                  elsif listener.respond_to?(:call)
                     listener.call( event )   
                  else
                     raise ArgumentError.new("Listener must be a Hash or Block")
                  end
                end
            end
         end

   end
end
