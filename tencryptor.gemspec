# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tencryptor/version'

Gem::Specification.new do |s|
  s.name          = 'tencryptor'
  s.version       = Tencryptor::VERSION
  s.authors       = ['mryoshio']
  s.email         = ['yoshiokaas@tachibanakikaku.com']
  s.summary       = %q{Tencryptor gem.}
  s.description   = %q{Gem for Tencryptor.}
  s.homepage      = ''
  s.license       = 'GPLv3'

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_development_dependency 'bundler', '~> 1.7'
  s.add_development_dependency 'rake', '~> 10.0'
end
