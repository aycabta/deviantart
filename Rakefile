require "bundler/gem_tasks"
require "rake/testtask"
require "readline"

test_pettern = FileList['test/**/*_test.rb']

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = test_pettern
end

Rake::TestTask.new(:real) do |t|
  AUTHORIZATION_CODE_FILE = 'test/fixtures/authorization_code.json'
  BROWSER_COMMAND = 'test/browser_command'
  if !File.exists?(AUTHORIZATION_CODE_FILE)
    OUTPUT_PIPE = 'test/output_pipe'
    if File.exists?(OUTPUT_PIPE)
      File.unlink(OUTPUT_PIPE)
    end
    File.mkfifo(OUTPUT_PIPE)
    if !File.exists?(BROWSER_COMMAND)
      browser_command = Readline.readline('Input your browser command> ')
      open(BROWSER_COMMAND, 'w') do |f|
        f.write(browser_command)
      end
      puts "Wrote \"#{browser_command}\" to #{BROWSER_COMMAND}"
    else
      open(BROWSER_COMMAND, 'r') do |f|
        browser_command = f.read
      end
    end
    fork do
      sleep 1
      fork do
        sleep 1
        puts 'Open browser for authorization'
        system("#{browser_command} http://localhost:4567/auth/deviantart")
      end
      puts 'Boot Sinatra OAuth consumer...'
      system('bundle exec ruby test/oauth_consumer.rb > /dev/null 2>&1')
    end
    result = open(OUTPUT_PIPE).read
    puts 'Got access token!'
    File.unlink(OUTPUT_PIPE)
    open(AUTHORIZATION_CODE_FILE, 'w') do |f|
      f.write(result)
    end
  end
  t.ruby_opts << '-I. -e "ENV[\'REAL\']=\'1\'"'
  t.loader = :direct
  t.libs << "test"
  t.libs << "lib"
  t.test_files = test_pettern
end

task :default => :test
