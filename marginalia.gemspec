Gem::Specification.new do |gem|
  gem.authors       = ["Noah Lorang", "Nick Quaranto", "Taylor Weibley"]
  gem.email         = ["noah@37signals.com", "github@arthurnn.com"]
  gem.homepage      = "https://github.com/basecamp/marginalia"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test}/*`.split("\n")
  gem.name          = "marginalia"
  gem.require_paths = ["lib"]
  gem.version       = "1.5.0"
  gem.license       = "MIT"

  gem.add_dependency "pg", "~> 0.21"

  gem.add_development_dependency "activerecord", ">= 2.3"
  gem.add_development_dependency "sequel"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "mocha"

  gem.summary = gem.description = %q{Attach comments to your ActiveRecord/Sequel queries.}
end
