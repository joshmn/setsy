lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'setsy/version'

Gem::Specification.new do |spec|
  spec.name          = 'setsy'
  spec.version       = Setsy::VERSION
  spec.authors       = ['Josh Brody']
  spec.email         = ['josh@josh.mn']
  spec.licenses      = ['MIT']

  spec.required_ruby_version = '>= 2.2'
  spec.summary       = 'Settings for your classes'
  spec.description   = 'Settings for your classes'
  spec.homepage      = 'https://github.com/joshmn/setsy'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.files += Dir['lib/**/*.rb']

  spec.add_dependency 'activemodel', '>= 3.0'
  spec.add_development_dependency 'rails', '>= 3.0'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry', '~> 0.11.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
end