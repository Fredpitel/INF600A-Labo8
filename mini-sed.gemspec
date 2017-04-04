# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','mini-sed','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'mini-sed'
  s.version = MiniSed::VERSION
  s.author = 'Your Name Here'
  s.email = 'your@email.address.com'
  s.homepage = 'http://your.website.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Une version simplifiee de sed'
  s.description = 'Une version simplifiee de sed, avec des commandes a la git. Utilise comme labo pour illustrer les gems, dont gli'
  s.files = `git ls-files`.split("\x0")
    .reject { |f| f =~ /prive/i }

  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','mini-sed.rdoc']
  s.rdoc_options << '--title' << 'mini-sed' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'mini-sed'
  s.add_development_dependency('rake', '~> 11.1')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba', '0.8.1')
  s.add_development_dependency('minitest', '5.4.3')
  s.add_runtime_dependency('gli','2.12.0')
end
