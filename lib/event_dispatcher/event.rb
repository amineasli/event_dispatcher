module EventDispatcher
   module Event
      attr_accessor :stop_propagation
      # A listener can prevent any other listeners from being called. 
      def initialize
         @stop_propagation = false
      end
   end
end
