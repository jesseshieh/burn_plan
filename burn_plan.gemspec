# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'burn_plan/version'

Gem::Specification.new do |spec|
  spec.name          = "BurnPlan"
  spec.version       = BurnPlan::VERSION
  spec.authors       = ["Jesse Shieh"]
  spec.email         = ["jesse.shieh.pub@gmail.com"]
  spec.description   = %q{Simulates your financial portfolio thousands of times across decades to determine your likelihood of running out of money before you die.}
  spec.summary       = %q{Personal financial portfolio simulator}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
