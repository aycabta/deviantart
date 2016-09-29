require "bundler/gem_tasks"
require "rake/testtask"
require "readline"

test_pettern = FileList['test/**/*_test.rb']

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = test_pettern
end

def get_browser_command
  browser_command_file = 'test/browser_command'
  if !File.exists?(browser_command_file)
    browser_command = Readline.readline('Input your browser command> ')
    open(browser_command_file, 'w') do |f|
      f.write(browser_command)
    end
    puts "Wrote \"#{browser_command}\" to #{browser_command_file}"
    browser_command
  else
    open(browser_command_file, 'r').read
  end
end

def get_access_token
  cv = ConditionVariable.new
  mutex = Mutex.new
  is_pinged = false
  Thread.new {
    mutex.synchronize {
      puts 'Boot Sinatra OAuth consumer...'
      system('bundle exec ruby test/oauth_consumer.rb > /dev/null 2>&1 &')
      open(OUTPUT_PIPE).read # block to get 'ping'
      is_pinged = true
      cv.signal
    }
  }
  is_browsed = false
  Thread.new {
    mutex.synchronize {
      until is_pinged
        cv.wait(mutex)
      end
      puts 'Open browser for authorization'
      system("#{get_browser_command} http://localhost:4567/auth/deviantart &")
      is_browsed = true
      cv.signal
    }
  }
  result = nil
  mutex.synchronize {
    until is_browsed
      cv.wait(mutex)
    end
    result = open(OUTPUT_PIPE).read # block to get authorization code
  }
  puts 'Got access token!'
  open(AUTHORIZATION_CODE_FILE, 'w') do |f|
    f.write(result)
  end
end

Rake::TestTask.new(:real) do |t|
  AUTHORIZATION_CODE_FILE = 'test/fixtures/authorization_code.json'
  if !File.exists?(AUTHORIZATION_CODE_FILE)
    OUTPUT_PIPE = 'test/output_pipe'
    if File.exists?(OUTPUT_PIPE)
      File.unlink(OUTPUT_PIPE)
    end
    File.mkfifo(OUTPUT_PIPE)
    get_access_token
    File.unlink(OUTPUT_PIPE)
  end
  t.ruby_opts << '-I. -e "ENV[\'REAL\']=\'1\'"'
  t.loader = :direct
  t.libs << "test"
  t.libs << "lib"
  t.test_files = test_pettern
end

task :default => :test
