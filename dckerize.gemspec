# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dckerize/version'

Gem::Specification.new do |spec|
  spec.name          = "dckerize"
  spec.version       = Dckerize::VERSION
  spec.authors       = ["Pablo Acuña"]
  spec.email         = ["pabloacuna88@gmail.com"]

  spec.summary       = %q{Supercharged Rails environment using Docker and Vagrant.}
  spec.homepage      = "https://github.com/pacuna/dckerize"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib", "templates"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
