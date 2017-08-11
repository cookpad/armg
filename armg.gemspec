# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'armg/version'

Gem::Specification.new do |spec|
  spec.name          = 'armg'
  spec.version       = Armg::VERSION
  spec.authors       = ['Genki Sugawara']
  spec.email         = ['sugawara@cookpad.com']

  spec.summary       = %q{Add MySQL geometry type to Active Record.}
  spec.description   = %q{Add MySQL geometry type to Active Record.}
  spec.homepage      = 'https://github.com/winebarrel/armg'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '~> 5'
  spec.add_dependency 'rgeo'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'mysql2'
  spec.add_development_dependency 'rspec-match_fuzzy'
end
