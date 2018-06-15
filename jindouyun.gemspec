lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jindouyun/version'

Gem::Specification.new do |spec|
  spec.name          = 'jindouyun'
  spec.version       = Jindouyun::VERSION
  spec.authors       = ['FENG Zhichao']
  spec.email         = ['flankerfc@gmail.com']

  spec.summary       = %q{Dingding (Dingtalk)}
  spec.description   = %q{Dingding (Dingtalk)}
  spec.homepage      = 'https://github.com/flanker/jindouyun'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'aescrypt'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
