# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'deviantart/version'

Gem::Specification.new do |spec|
  spec.name          = "deviantart"
  spec.version       = DeviantArt::VERSION
  spec.authors       = ["Code Ass"]
  spec.email         = ["aycabta@gmail.com"]

  spec.summary       = %q{deviantART API library}
  spec.description   = %Q{deviantART API library\n}
  spec.homepage      = "https://github.com/aycabta/deviantart"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "minitest", "~> 5.10"
end
