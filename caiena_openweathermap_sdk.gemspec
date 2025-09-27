# frozen_string_literal: true

require_relative "lib/caiena_openweathermap_sdk/version"

Gem::Specification.new do |spec|
  spec.name = "caiena_openweathermap_sdk"
  spec.version = CaienaOpenweathermapSdk::VERSION
  spec.authors = ["peterson.bem"]
  spec.email = ["petersondaronch@icloud.com"]

  spec.summary = "Use this SDK to access weather information from Open Weather Map API"
  spec.description = "SDK for Open Weather Map API access"
  spec.homepage = "https://github.com/petersonddb/caiena-openweathermap-sdk"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/petersonddb/caiena-openweathermap-sdk"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .rubocop.yml])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
