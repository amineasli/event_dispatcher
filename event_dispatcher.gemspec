Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'event_dispatcher'
  s.version     = '0.1.0'
  s.date        = '2013-12-17'
  s.summary     = "event_dispatcher implements a lightweight version of the Observer design pattern."
  s.description = "event_dispatcher gem provides a simple observer implementation, allowing you to subscribe and listen for events in your application in a simple and effective way. It is very strongly inspired by the Symfony EventDispatcher component"
  s.required_ruby_version = '>= 1.9.3'
  s.author       = 'Amine Asli'
  s.email        = 'phobosapp@yahoo.com'
  s.files        = Dir['LICENCE', 'Rakefile', 'README.md', 'CHANGELOG.md', 'lib/**/*']
  s.test_files   = Dir.glob('test/*')
  s.require_path = 'lib'
  s.homepage     = 'https://github.com/ThatAmine/event_dispatcher' 
  s.license      = 'LGPL'
end

