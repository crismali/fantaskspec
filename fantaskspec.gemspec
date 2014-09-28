# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fantaskspec/version"

Gem::Specification.new do |spec|
  spec.name          = "fantaskspec"
  spec.version       = Fantaskspec::VERSION
  spec.authors       = ["Michael Crismali"]
  spec.email         = ["michael.crismali@gmail.com"]
  spec.summary       = %q{Makes it easy to test your Rake tasks with RSpec.}
  spec.description   = %q{Makes it easy to test your Rake tasks with RSpec.}
  spec.homepage      = "https://github.com/crismali/fantaskspec"
  spec.license       = "Apache"

  spec.files         = Dir["lib/**/*", "LICENSE", "README.md"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rake", "~> 10.0"
  spec.add_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-nav"
end
