module EventDispatcher
   module Event
      def propagation_stopped
         @propagation_stopped ||= false
      end

      def stop_propagation
         @propagation_stopped = true
      end

      def propagation_stopped?
         propagation_stopped
      end
   end
end
