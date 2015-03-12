event_dispatcher
====================

[![Gem Version](https://badge.fury.io/rb/event_dispatcher.png)](http://badge.fury.io/rb/event_dispatcher)

event_dispatcher gem provides a simple observer implementation, allowing you to subscribe and listen for events in your application with a simple and effective way. 

It is very strongly inspired by the [Symfony EventDispatcher component](http://symfony.com/components/EventDispatcher)

## Install
Install the gem :

    gem install event_dispatcher

Accessing the gem :

    require 'event_dispatcher'

## Usage
### Creating an Event
When an event is dispatched, it's identified by a unique name, which any number of listeners might be listening to. An event instance is also created and passed to all of the listeners : 

    class UserEvent
       attr_reader :user, :login_time
       
       def initialize(user, login_time)
          @user = user
          @login_time = login_time
       end
     
       def log
         "#{login_time} : User #{user} has just logged in."
       end
    end

### Creating an EventDispatcher
The Dispatcher is the commander of the event dispatcher system, it maintains a registry of listeners. It's responsible for notifying listeners when events are dispatched :

    dispatcher = EventDispatcher::Dispatcher.new

### Connecting Listeners
To take advantage of an existing event, a listener needs to be connected to the dispatcher so that it can be notified when the event is dispatched. There are two ways for attaching a listener to the dispatcher.

Using a block :

    listener = lambda do |event|
       puts event.log
    end
    
    dispatcher.add_listener(:user_login, listener)

Or using a class instance with a handler method for the event : 

    class UserEventListener
       def handle(event)
          puts event.log
       end
    end
   
    listener = UserEventListener.new     
    dispatcher.add_listener(:user_login, listener.method(:handle))

You may also specify a priority when subscribing to events. Listeners with higher priority will be run first :

    dispatcher.add_listener(:user_login, listener1, 15) 
    dispatcher.add_listener(:user_login, listener2, 10) 
    dispatcher.add_listener(:user_login, listener3, 2) 


### Dispatching an Event
Notifies all listeners of the given event, so the event instance is then passed to each listener :

    event = UserEvent.new('Bobby', Time.now) 
    dispatcher.dispatch(:user_login, event)

### Stopping Event propagation
You may wish to stop the propagation of an event to other listeners. To do so you need to first mixing the module Event in your custom event class, then setting the event instance variable `stop_propagation` to true : 	

    class UserEvent
       include EventDispatcher::Event
       # ... 
       # ... 
    end

    listener = lambda do |event|
       puts event.log
       event.stop_propagation = true
    end

### Removing Listeners
Removes an event listener from the specified event :

    dispatcher.remove_listener!(:user_login, listener)

Removes a collection of listeners from the specified event :

    dispatcher.remove_listeners!(:user_login) # calling remove_listeners! without argument will simply reset the entire listeners container

## Tests
    rake test

## License
LGPL, see LICENSE.


