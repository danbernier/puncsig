require './lib/puncsig/version'

spec = Gem::Specification.new do |s|
  s.name = 'puncsig'
  s.version = Puncsig::VERSION

  s.summary = %{
    PuncSig: Punctuation Signatures for your ruby methods
  }.strip.gsub(/\s+/, ' ')

  s.description = %{

    A method's punctuation signature is its source, minus all letters,
    numbers, and whitespace. It can help you find similar methods,
    find long methods, and see how your methods are balanced.

    PuncSig parses your ruby classes and prints a report on your
    classes' punctuation signatures.

  }.strip.gsub(/\s+/, ' ')

  s.files = Dir['lib/**/*.rb'] + Dir['test/**/*.rb'] + %w[
    README.md
    Rakefile
    lib/tasks/puncsig.rake
    puncsig.gemspec
  ]

  s.require_path = 'lib'
  s.required_ruby_version = ">= 1.8.7"

  s.author = "Dan Bernier"
  s.email = "danbernier@gmail.com"
  s.homepage = "https://github.com/danbernier/puncsig"
end
