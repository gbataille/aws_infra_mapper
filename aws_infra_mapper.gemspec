# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aws_infra_mapper/version'

Gem::Specification.new do |spec|
  spec.name          = 'aws_infra_mapper'
  spec.version       = AwsInfraMapper::VERSION
  spec.authors       = ['Grégory Bataille']
  spec.email         = ['gregory.bataille@gmail.com']
  spec.summary       = 'A simple CLI tool to visualize your AWS infrastructure'
  spec.description   = ''
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = Dir[
    'README.md', 'bin/aws_infra_mapper', '{lib,spec}/**/*.rb', 'utils/**/*.*'
  ]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'aws-sdk', '~> 3.0'
  spec.add_runtime_dependency 'colorize', '~> 0.8'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'factory_bot', '~> 4.0'
  spec.add_development_dependency 'faker', '~> 1.8'
  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'guard-rubocop', '~> 1.3'
  spec.add_development_dependency 'pry', '~> 0.11'
  spec.add_development_dependency 'pry-byebug', '~> 3.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.7'
  spec.add_development_dependency 'rubocop', '~> 0.54'
end
