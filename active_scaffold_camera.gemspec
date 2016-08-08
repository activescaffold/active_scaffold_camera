# -*- encoding: utf-8 -*-
$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'active_scaffold_camera/version'

Gem::Specification.new do |s|
  s.name = %q{active_scaffold_camera}
  s.version = ActiveScaffoldCamera::Version::STRING

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Sergio Cambra", "Volker Hochstein"]
  s.summary = %q{Snapshot form_ui using saycheese.js}
  s.description = %q{Helper to take a snapshot from camera on ActiveScaffold forms, using saycheese.js}
  s.email = %q{activescaffold@googlegroups.com}
  s.homepage = %q{http://github.com/activescaffold/active_scaffold_camera}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.textile"
  ]
  s.files = Dir["{app,config,lib}/**/*"] + %w[LICENSE README.textile]
  s.test_files = Dir["test/**/*"]
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]

  s.add_development_dependency(%q<bundler>, ["~> 1.0"])
  s.add_runtime_dependency(%q<active_scaffold>, [">= 3.4.0"])
end

