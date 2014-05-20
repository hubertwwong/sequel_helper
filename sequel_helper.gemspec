Gem::Specification.new do |s|
  s.name        = "sequel_helper"
  s.version     = "0.0.8"
  s.date        = "2014-05-18"
  s.summary     = "some helper functions for the sequel gem to make things more rubyish."
  s.description = "A simple sequel helper for some common sql stuff."
  s.authors     = "Hubert Wong"
  s.email       = "hubertwwong@gmail.com"
  s.files       = [
                    "lib/sequel_helper.rb",
                    "lib/sequel_helper/gen/gen_insert.rb",
                    "lib/sequel_helper/gen/gen_load_data.rb",
                    "lib/sequel_helper/gen/gen_update.rb",
                    "lib/sequel_helper/gen/gen_string.rb"
                  ]
  s.homepage    = "http://www.localhost.com"
  s.license     = "MIT"
end
