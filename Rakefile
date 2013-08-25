require 'bundler'
Bundler::GemHelper.install_tasks

desc "Open a console with the project loaded and the UriMapper namespace included"
task :console do
  require 'pry'
  $: << File.expand_path('lib')
  require 'uri_mapper'
  include UriMapper
  Pry.start
end
