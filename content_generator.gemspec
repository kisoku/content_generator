$:.unshift(File.dirname(__FILE__) + '/lib')
require 'content_generator/version'

Gem::Specification.new do |s|
  s.name = 'content_generator'
  s.version = ContentGenerator::VERSION
  s.platform = Gem::Platform::RUBY
  s.summary = 'framework for generating content from a chef resource'
  s.description = s.summary
  s.author = 'Mathieu Sauve-Frankel'
  s.email = 'msf@kisoku.net'
  s.homepage = 'http://kisoku.github.io'
  s.license = 'Apache 2.0'
  s.add_development_dependency 'halite', '>= 1.0.0.a'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.bindir = 'bin'
  s.executables = []
  s.require_path = 'lib'
  s.files = %w(LICENSE README.md CHANGELOG.md Rakefile) + Dir.glob('{lib,spec}/**/*', File::FNM_DOTMATCH).reject {|f| File.directory?(f)}
end
