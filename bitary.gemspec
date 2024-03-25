# frozen_string_literal: true

require_relative 'lib/bitary/version'

Gem::Specification.new do |spec|
  spec.name = 'bitary'
  spec.version = Bitary::VERSION
  spec.authors = ['Maximilien Ballesteros']
  spec.email = ['maxou.info@gmail.com']

  spec.summary = 'Bit array data structure'
  spec.description = 'Ruby-based implementation of the bit array data structure'
  spec.homepage = 'https://github.com/Patacode/bitary'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.3.0'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/Patacode/bitary'
  spec.metadata['changelog_uri'] = 'https://github.com/Patacode/bitary/blob/main/CHANGELOG.md'

  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added
  # into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
