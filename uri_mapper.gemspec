require File.expand_path('../lib/uri_mapper/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'uri_mapper'
  s.version     = UriMapper::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Andrew Radev']
  s.email       = ['andrey.radev@gmail.com']
  s.homepage    = 'http://github.com/AndrewRadev/uri_mapper'
  s.summary     = 'TODO'
  s.description = <<-D
    TODO
  D

  s.add_dependency 'rack', '>= 1.5.2'

  s.add_development_dependency 'rspec', '>= 2.0.0'
  s.add_development_dependency 'rake'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'uri_mapper'

  s.files        = Dir['{lib}/**/*.rb', 'bin/*', 'LICENSE', '*.md']
  s.require_path = 'lib'
  s.executables  = ['uri_mapper']
end
