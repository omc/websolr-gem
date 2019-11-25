# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  spec.name          = 'websolr'
  spec.version       = '0.0.1'

  spec.authors       = ['Rob Sears']
  spec.email         = ['rob@onemorecloud.com']

  spec.summary       = 'Optimize your Websolr integration'
  spec.description   = <<-DESCRIPTION
  This gem creates a special connection class which allows RSolr/Sunspot to
  communicate with Websolr using Typhoeus. This introduces HTTP Keep-Alive,
  load balancing, and support for authentication, with no additional user
  configuration required.
  DESCRIPTION

  spec.homepage      = 'https://github.com/omc/websolr-gem'
  spec.license       = 'MIT'

  spec.files         = ['lib/websolr.rb',
                        'lib/websolr/railtie.rb']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency "typhoeus", ['~> 1']

  spec.add_development_dependency 'bundler', '~> 1'
  spec.add_development_dependency 'rake', '< 11.0'
  spec.add_development_dependency 'rspec', '~> 3.5'
end
# rubocop:enable Metrics/BlockLength
