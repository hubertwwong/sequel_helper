# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sequel_helper/version'

Gem::Specification.new do |spec|
  spec.name          = "sequel_helper"
  spec.version       = SequelHelper::VERSION
  spec.date          = "2014-05-18"
  spec.summary       = "some helper functions for the sequel gem to make things more rubyish."
  spec.description   = "A simple sequel helper for some common sql stuff."
  spec.authors       = "Hubert Wong"
  spec.email         = "hubertwwong@gmail.com"
  spec.homepage      = "http://www.localhost.com"
  spec.license       = "MIT"

  spec.add_dependency "engtagger"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.files         = `git ls-files`.split($/)
  #spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  #spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


# spec.files       = [
#                    "lib/sequel_helper.rb",
#                    "lib/sequel_helper/gen/gen_insert.rb",
#                    "lib/sequel_helper/gen/gen_load_data.rb",
#                    "lib/sequel_helper/gen/gen_update.rb",
#                    "lib/sequel_helper/gen/gen_string.rb"
#                  ]


end
