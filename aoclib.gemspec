Gem::Specification.new do |s|
  s.name = 'aoclib'
  s.version = '0.0.2'
  s.authors = ['Adam Doppelt']
  s.email = 'amd@gurge.com'

  s.summary = 'aoclib - helpers for Advent of Code puzzles'
  s.description = 'aoclib makes Advent of Code a bit more pleasant'
  s.homepage = 'http://github.com/gurgeous/aoclib'
  s.license = 'MIT'
  s.required_ruby_version = '>= 2.7.0'

  # what's in the gem?
  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { _1.match(%r{^test/}) }
  end
  s.require_paths = ['lib']
end
