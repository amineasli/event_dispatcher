Ruby-EventDispatcher
====================

[![Gem Version](https://badge.fury.io/rb/event_dispatcher.png)](http://badge.fury.io/rb/event_dispatcher)

EventDispatcher implements a lightweight version of the Observer design pattern. It's a Ruby port of the well known Symfony EventDispatcher

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


