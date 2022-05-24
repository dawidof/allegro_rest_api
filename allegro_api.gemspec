# frozen_string_literal: true

require_relative "lib/allegro_api/version"

Gem::Specification.new do |spec|
  spec.name = "allegro_api"
  spec.version = AllegroApi::VERSION
  spec.authors = ["Dmytro Koval"]
  spec.email = ["dawidofdk@o2.pl"]

  spec.summary = "Simple API REST client for allegro.pl using device auth"
  spec.homepage = "https://github.com/dawidof/allegro_api"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/dawidof/allegro_api"
  spec.metadata["changelog_uri"] = "https://github.com/dawidof/allegro_api/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "json", ">= 1.8.6"
end
