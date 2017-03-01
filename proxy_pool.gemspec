# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'proxy_pool/version'

Gem::Specification.new do |s|
  s.name     = 'proxy_pool'
  s.version  = ProxyPool::Version::VERSION
  s.author   = 'Manh Dao Van'
  s.email    = 'manhdaovan@gmail.com'
  s.homepage = 'https://github.com/manhdaovan/proxy_pool'
  s.license  = 'UNLICENSE|http://unlicense.org/'

  s.summary     = 'A command line tool to create a pool of proxies with one entry point'
  s.description = <<-eos
    later
  eos

  s.platform              = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.1.0'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test}/*`.split("\n")
  s.require_paths = ['lib']

  s.executables        = s.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  s.default_executable = 'proxy_pool'
  s.bindir             = 'bin'

  s.add_dependency('excon', '0.55.0')
  s.add_dependency('nokogiri', '1.7.0.1')
  s.add_development_dependency('rake')
end
