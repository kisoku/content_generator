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
  s.add_development_dependency 'rake', '~> 10.4.2'
  s.add_development_dependency 'bundler', '~> 1.6'
  s.add_development_dependency 'rspec', '~> 3.1.0'
  s.add_development_dependency 'rspec-its', '~> 1.1.0'
  s.add_development_dependency 'chefspec', '~> 4.2'
  s.add_development_dependency 'fuubar', '~> 2.0.0'
  s.add_development_dependency 'halite', '~> 1.0.0.rc.1'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'simplecov', '~> 0.9.1'
  s.add_development_dependency 'test-kitchen', '~> 1.3.1'
  s.add_development_dependency 'kitchen-vagrant'
  s.add_development_dependency 'vagrant-wrapper'
  s.add_development_dependency 'kitchen-docker'
  s.add_development_dependency 'kitchen-sync'
  s.add_development_dependency 'berkshelf'

  s.bindir = 'bin'
  s.executables = []
  s.require_path = 'lib'
  s.files = %w(LICENSE README.md CHANGELOG.md Rakefile) + Dir.glob('{lib,spec}/**/*', File::FNM_DOTMATCH).reject {|f| File.directory?(f)}

  s.files = `git ls-files`.split($/)
end
