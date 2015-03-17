# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rs_path_tokenizer/version'

Gem::Specification.new do |spec|
  spec.name          = "rs_path_tokenizer"
  spec.version       = RsPathTokenizer::VERSION
  spec.authors       = ["glebtv", "Sergey Malykh"]
  spec.email         = ["xronos.i.am@gmail.com"]

  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  # end

  spec.summary       = %q{URL path tokenizer.}
  spec.description   = %q{Tokenize path from predefined tokens.}
  spec.homepage      = "http://github.com/xronos-i-am/rs_path_tokenizer"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/).reject { |f| puts f; f.match(/.*\.gem/) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
