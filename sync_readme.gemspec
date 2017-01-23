# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sync_readme/version'

Gem::Specification.new do |spec|
  spec.name          = 'sync_readme'
  spec.version       = SyncReadme::VERSION
  spec.authors       = ['Alex Ives']
  spec.email         = ['alex.ives@govdelivery.com']

  spec.summary       = 'Syncs a readme with confluence'
  spec.description   = 'Converts the readme.md file in the base of a repo and syncs it with the confluence page'
  spec.homepage      = 'http://dev-scm.office.gdi/development/sync_readme'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 0.11'
  spec.add_dependency 'redcarpet', '~> 3.4.0'
  spec.add_dependency 'dotenv', '~> 2.1.2'

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.47'
  spec.add_development_dependency 'pry', '~> 0.10.4'
end
