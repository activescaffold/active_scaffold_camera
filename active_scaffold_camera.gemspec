# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require 'active_scaffold_camera/version'

Gem::Specification.new do |s|
  s.name = 'active_scaffold_camera'
  s.version = ActiveScaffoldCamera::Version::STRING

  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.authors = ['Sergio Cambra', 'Volker Hochstein']
  s.summary = 'Snapshot form_ui using saycheese.js'
  s.description = 'Helper to take a snapshot from camera on ActiveScaffold forms, using saycheese.js'
  s.email = 'activescaffold@googlegroups.com'
  s.homepage = 'http://github.com/activescaffold/active_scaffold_camera'
  s.extra_rdoc_files = [
    'LICENSE',
    'README.md'
  ]
  s.files = Dir['{app,config,lib}/**/*'] + %w[LICENSE README.md]
  s.licenses = ['MIT']
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 3.2'

  s.add_dependency('active_scaffold', ['>= 3.4.0'])
  s.metadata['rubygems_mfa_required'] = 'true'
end
