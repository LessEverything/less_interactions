# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "less_interactions"
  spec.version       = Less::Interaction::VERSION
  spec.authors       = ["Eugen Minciu", "Steven Bristol"]
  spec.email         = ["eugen@lesseverything.com", "steve@lesseverything.com"]
  spec.summary       = "A better way to think about Rails application"
  spec.description   = "less_interactions lets you structure your Rails applications in a saner way thanks to the interaction/interactor/command pattern."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
