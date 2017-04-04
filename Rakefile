require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'rdoc/task'
require 'cucumber'
require 'cucumber/rake/task'

MINI_SED = 'bundle exec bin/mini-sed'

# Sur mon MacBook, avec emacs, je prefere desactiver les couleurs.
CUCUMBER_COLOR = %x{uname} =~ /Darwin/ ? '--no-color' : ''

###################################################
# Taches pour les exercices du labo 8 sur mini-sed
###################################################


# IMPORTANT: A FAIRE APRES AVOIR TELECHARGE!
task :ch_perms do
 sh "chmod +x bin/mini-sed"
end

task :default => :exercice_a # A commenter/modifier pour les autres exercices
#task :default => :exercice_b
#task :default => :exercice_c
#task :default => :exercice_d
task :default => :exercices

task :exercice_a => :test_delete

task :exercice_b => :test_print

task :exercice_c => :acceptation_delete

task :exercice_d => :features_print

task :exercices => [:a, :b, :c, :d].map { |x| "exercice_#{x}".to_sym }

###################################################

task :test_delete do
     sh "rake test TEST=test/delete_test.rb"     
end

task :test_print do
     sh "rake test TEST=test/print_test.rb"     
end

task :test_substitute do
     sh "rake test TEST=test/substitute_test.rb"     
end

task :acceptation_delete do
     sh "rake test_acceptation TEST=test_acceptation/delete_test.rb"
end

task :acceptation_print do
     sh "rake test_acceptation TEST=test_acceptation/print_test.rb"
end

task :features_print do
     sh "cucumber --format progress #{CUCUMBER_COLOR} features/print.feature"
     sh "cucumber --format progress #{CUCUMBER_COLOR} features/print-in-place.feature"
end


###################################################


###################################################

Rake::RDocTask.new do |rd|
  rd.main = "README.rdoc"
  rd.rdoc_files.include("README.rdoc","lib/**/*.rb","bin/**/*")
  rd.title = 'Your application title'
end

###################################################

spec = eval(File.read('mini-sed.gemspec'))

Gem::PackageTask.new(spec) do |pkg|
end

CUKE_RESULTS = 'results.html'
CLEAN << CUKE_RESULTS << 'tmp'
desc 'Run features'
Cucumber::Rake::Task.new(:features) do |t|
  opts = "features --format html -o #{CUKE_RESULTS} --format progress -x #{CUCUMBER_COLOR} --tags ~@ignore" if %x{uname} =~ /Darwin/
  opts += " --tags #{ENV['TAGS']}" if ENV['TAGS']
  t.cucumber_opts =  opts
  t.fork = false unless ENV['HOSTNAME'] =~ /java/
end

desc 'Run features tagged as work-in-progress (@wip)'
Cucumber::Rake::Task.new('features:wip') do |t|
  tag_opts = ' --tags ~@pending --tags ~@ignore'
  tag_opts += ' --tags @wip'
  t.cucumber_opts = "features --format html -o #{CUKE_RESULTS} --format progress -x #{CUCUMBER_COLOR} -s#{tag_opts}"
  t.fork = false
end

task :cucumber => :features
task 'cucumber:wip' => 'features:wip'
task :wip => 'features:wip'

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
end

Rake::TestTask.new(:test_acceptation) do |t|
  t.libs << "test_acceptation"
  t.test_files = FileList['test_acceptation/*_test.rb']
end

###################################################

task :exemples_s do
  sh %{bundle exec bin/mini-sed substitute m1 c1}
  sh %{bundle exec bin/mini-sed substitute -g m1 c1}
  sh %{bundle exec bin/mini-sed --in_place=bak substitute -g m1 c1}
end

task :exemples_d do
  sh %{bundle exec bin/mini-sed delete m1}
end

task :exemples_p do
  sh %{bundle exec bin/mini-sed print m1}
end

task :exemples_i do
  sh %{bundle exec bin/mini-sed insert m1}
end

task :exemples_fichiers do
  sh %{bundle exec bin/mini-sed substitute m1 c1 < README.rdoc}
  sh %{bundle exec bin/mini-sed substitute m1 c1 README.rdoc}
  sh %{bundle exec bin/mini-sed print m1 README.rdoc README.rdoc}
  sh %{bundle exec bin/mini-sed delete m1 README.rdoc Rakefile}
end

task :exemples => [:exemples_fichiers, :exemples_s]

task :exemples_diapos do
  sh MINI_SED + ' substitute "[a-z]*.[0-9]" XXX'
  sh MINI_SED + ' --in_place=bak substitute -g "foo" "bar" foo.txt README.doc'
end
