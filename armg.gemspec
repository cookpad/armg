# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'armg/version'

Gem::Specification.new do |spec|
  spec.name          = 'armg'
  spec.version       = Armg::VERSION
  spec.authors       = ['Genki Sugawara']
  spec.email         = ['sugawara@cookpad.com']

  spec.summary       = 'Add MySQL geometry type to Active Record.'
  spec.description   = 'Add MySQL geometry type to Active Record.'
  spec.homepage      = 'https://github.com/cookpad/armg'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'activerecord', '>= 6', '< 8'
  spec.add_dependency 'rgeo'
  spec.add_development_dependency 'appraisal', '>= 2.2.0'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'erbh', '>= 0.1.2'
  spec.add_development_dependency 'mysql2'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-match_ruby', '>= 0.1.3'
  spec.add_development_dependency 'rubocop', '>= 1.7.0'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
end
