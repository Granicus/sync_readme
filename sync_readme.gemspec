# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sync_readme/version'

Gem::Specification.new do |spec|
  spec.name          = 'sync_readme'
  spec.version       = SyncReadme::VERSION
  spec.authors       = ['Alex Ives']
  spec.email         = ['alex.ives@govdelivery.com']

  spec.summary       = 'Syncs markdown files with confluence'
  spec.description   = 'Converts markdown files and synchronizes them with confluence pages'
  spec.homepage      = 'https://github.com/govdelivery/sync_readme'
  spec.license       = 'BSD-3-Clause'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.11'
  spec.add_dependency 'kramdown', '~> 1.13'
  spec.add_dependency 'dotenv', '~> 2'
  spec.add_dependency 'highline', '~> 1'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.81'
  spec.add_development_dependency 'pry', '~> 0.10.4'
end
