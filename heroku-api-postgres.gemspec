# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'heroku/api/postgres/version'

Gem::Specification.new do |spec|
  spec.name          = 'heroku-api-postgres'
  spec.version       = Heroku::Api::Postgres::VERSION
  spec.authors       = ['Alessandro Rodi']
  spec.email         = ['coorasse@gmail.com']

  spec.summary       = 'Ruby library to invoke Heroku Postgres APIs'
  spec.description   = 'Ruby library to invoke Heroku Postgres APIs'
  spec.homepage      = 'https://github.com/coorasse/heroku-api-postgres'
  spec.license       = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/coorasse/heroku-api-postgres'
  spec.metadata['changelog_uri'] = 'https://github.com/coorasse/heroku-api-postgres/blob/main/CHANGELOG.md'
  spec.metadata['funding_uri'] = 'https://github.com/sponsors/coorasse'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.2.0'

  spec.add_dependency 'platform-api'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
