# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rs_path_tokenizer/version'

Gem::Specification.new do |spec|
  spec.name          = "rs_path_tokenizer"
  spec.version       = RsPathTokenizer::VERSION
  spec.authors       = ["glebtv","Sergey Malykh"]
  spec.email         = ["xronos.i.am@gmail.com"]

  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  # end

  spec.summary       = %q{URL path tokenizer.}
  spec.description   = %q{Tokenize path from predefined tokens.}
  spec.homepage      = "http://github.com/xronos-i-am/rs_path_tokenizer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
