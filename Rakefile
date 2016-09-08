require "bundler/gem_tasks"
require "rake/testtask"

test_pettern = FileList['test/**/*_test.rb']

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = test_pettern
end

Rake::TestTask.new(:real) do |t|
  t.ruby_opts << '-e "ENV[\'REAL\']=\'1\'"'
  t.loader = :direct
  t.libs << "test"
  t.libs << "lib"
  t.test_files = test_pettern
end

task :default => :test
