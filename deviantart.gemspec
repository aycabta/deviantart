# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deviantart/version'

Gem::Specification.new do |spec|
  spec.name          = 'deviantart'
  spec.version       = DeviantArt::VERSION
  spec.authors       = ['Code Ass']
  spec.email         = ['aycabta@gmail.com']

  spec.summary       = %q{deviantART API library}
  spec.description   = <<-EOD
A Ruby interface to the deviantART API,
with some tokens from OAuth API.
  EOD
  spec.homepage      = 'https://github.com/aycabta/deviantart'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 2.2.8')

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'sinatra'
  spec.add_development_dependency 'omniauth'
  spec.add_development_dependency 'omniauth-oauth2', '~> 1.3.1'
  spec.add_development_dependency 'omniauth-deviantart'
  spec.add_development_dependency 'launchy'
end
