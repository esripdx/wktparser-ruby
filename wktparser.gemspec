# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wktparser/version'

Gem::Specification.new do |gem|
  gem.name          = "wktparser"
  gem.version       = Wktparser::VERSION
  gem.authors       = ["Jen Oslislo"]
  gem.email         = ["joslislo@esri.com"]
  gem.description   = %q{Well Known Text parser}
  gem.summary       = %q{Parse Well Known Text into Ruby objects}
  gem.homepage      = "https://github.com/esripdx/wktparser-ruby"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency 'whittle'
  gem.add_development_dependency 'minitest'
end
