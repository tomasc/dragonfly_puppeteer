
lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dragonfly_puppeteer/version'

Gem::Specification.new do |spec|
  spec.name          = 'dragonfly_puppeteer'
  spec.version       = DragonflyPuppeteer::VERSION
  spec.authors       = ['Tomáš Celizna']
  spec.email         = ['tomas.celizna@gmail.com']

  spec.summary       = 'Dragonfly plugin that uses Puppeteer to generate screenshots and PDFs'
  spec.homepage      = 'https://github.com/tomasc/dragonfly_puppeteer'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dragonfly', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'minitest-reporters'
end
