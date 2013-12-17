Ruby-EventDispatcher
====================

[![Gem Version](https://badge.fury.io/rb/event_dispatcher.png)](http://badge.fury.io/rb/event_dispatcher)

Event_dispatcher gem provides a simple observer implementation, allowing you to subscribe and listen for events in your application easily and elegantly.

## Install

    gem install event_dispatcher

## Usage

    require 'event_dispatcher'

    dispatcher = EventDispatcher::Dispatcher.new
    
    listener = lambda do |event|
       puts event.foo_bar
    end
    
    dispatcher.add_listener( 'foo_bar_action', listener )
    
    class FooBarEvent
       include EventDispatcher::Event
       def foo_bar
          'FooBar is working!'
       end
    end
    
    dispatcher.dispatch( 'foo_bar_action', FooBarEvent.new )


