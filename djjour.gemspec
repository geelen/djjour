# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'djjour/version'

Gem::Specification.new do |s|
  s.name        = 'djjour'
  s.version     = DJjour::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Glen Maddern', 'Ivan Vanderbyl', 'Pat Allan']
  s.email       = ['glenmaddern@gmail.com']
  s.homepage    = ''
  s.summary     = %q{Shared Music DJ}
  s.description = %q{Client and server DJ Music system that hooks into iTunes.}

  s.rubyforge_project = 'djjour'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_runtime_dependency 'dnssd',    '>= 2.0'
  s.add_runtime_dependency 'nokogiri', '>= 1.5.0'
  s.add_runtime_dependency 'sinatra',  '>= 1.2.6'
end
