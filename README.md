# deviantART API library

## Installation

```bash
$ gem install deviantart
```

## Usage

```ruby
da = DeviantArt::Client.new do |config|
  config.client_id = 9999
  config.client_secret = 'LMNOPQRSTUVWXYZZZZZZZZ9999999999'
  config.grant_type = :client_credentials
  # auto refresh access_token with Client Credentials Grant when expired
  config.access_token_auto_refresh = true
end

deviation = da.get_deviation('F98C2XXX-C6A8-XXXX-08F9-57CCXXXXX187')
deviation.title # => deviation's title
```

## Documantation

[On the RubyDoc.info](http://www.rubydoc.info/gems/deviantart)

## How to Test

At the first, install gems:

```bash
$ cd deviantart
$ bundle install
```

And you will run test with stub APIs:

```bash
$ bundle exec rake test
```

If you want to use **real** API in test, run this one:

```bash
$ bundle exec rake real
```

After this, Rake task performs some steps:

- creates named pipe
- OAuth consumer server launches internal
- opens your browser with authorization page

```bash
$ bundle exec rake real
Boot Sinatra OAuth consumer...
Open browser for authorization
```

The OAuth consumer server writes access token to named pipe and terminates after you permit it on browser.
Rake task takes authorization code via named pipe.
The tests run with it.

```bash
--snip--
Open browser for authorization
Got access token!
Loaded suite -e
Started
..............

Finished in 23.157618292 seconds.
---------------------------------
62 tests, 234 assertions, 0 failures, 0 errors, 0 pendings, 0 omissions, 0 notifications
100% passed
---------------------------------
```

The authorization code is cached at `test/fixtures/authorization_code.json`.

## API

## Official API Document

[Developers - DeviantArt](https://www.deviantart.com/developers/)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Badges

- [![Build Status](https://travis-ci.org/aycabta/deviantart.svg)](https://travis-ci.org/aycabta/deviantart)
- [![Build Status](https://ci.appveyor.com/api/projects/status/github/aycabta/deviantart?branch=master&svg=true)](https://ci.appveyor.com/project/aycabta/deviantart)
