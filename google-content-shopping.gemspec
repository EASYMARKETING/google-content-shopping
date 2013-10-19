# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'google/content/shopping/version'

Gem::Specification.new do |spec|
  spec.name          = "google-content-shopping"
  spec.version       = Google::Content::Shopping::VERSION
  spec.authors       = ["Patrick Detlefsen"]
  spec.email         = ["patrick.detlefsen@gmail.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.add_dependency "nokogiri", "~> 1.6"
  spec.add_dependency 'httparty', '~> 0.11.0'
  spec.add_dependency 'multi_xml', '~> 0.5'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest", "~> 4.7"
  spec.add_development_dependency "webmock", "~> 1.0"
  spec.add_development_dependency "pry", '~> 0.9.12'
end
