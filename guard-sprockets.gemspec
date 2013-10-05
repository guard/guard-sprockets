# encoding: utf-8
$:.push File.expand_path('../lib', __FILE__)
require 'guard/sprockets/version'

Gem::Specification.new do |s|
  s.name        = 'guard-sprockets'
  s.version     = Guard::SprocketsVersion::VERSION
  s.platform    = Gem::Platform::RUBY
  s.license     = 'MIT'
  s.authors     = ['Aaron Cruz', 'Kematzy']
  s.email       = ['remy@rymai.me']
  s.homepage    = 'https://rubygems.org/gems/guard-sprockets'
  s.summary     = 'Guard gem for Sprockets'
  s.description = 'Guard::Sprockets automatically packages your JavaScript files together.'

  s.required_ruby_version = '>= 1.9.2'

  s.add_runtime_dependency 'guard',     '~> 2.0'
  s.add_runtime_dependency 'execjs',    '~> 2.0'
  s.add_runtime_dependency 'sprockets', '~> 2.0'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rspec'

  s.files        = Dir.glob('{lib}/**/*') + %w[CHANGELOG.md LICENSE README.md]
  s.require_path = 'lib'
end
