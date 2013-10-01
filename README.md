Ruby-EventDispatcher
====================

EventDispatcher implements a lightweight version of the Observer design pattern. It's a Ruby port of the well known Symfony EventDispatcher

## Install

 ```gem install event_dispatcher```

## Usage

 ``` require 'event_dispatcher'

 dispatcher = EventDispatcher::Dispatcher.new
 
 listener = lambda do |event|
    puts event.foo_bar
 end
 
 dispatcher.add_listener( 'foo_bar_event', listener)
 
 class FooBarEvent
    include EventDispatcher::Event
    def foo_bar
       'FooBar is working!'
    end
 end
 
 dispatcher.dispatch( 'foo_bar_event', FooBarEvent.new )
 ```


