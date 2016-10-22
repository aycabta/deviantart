# deviantART API library

## Installation

    $ gem install deviantart

## Usage

```ruby
da = DeviantArt.new do |config|
  config.client_id = 9999
  config.client_secret = 'LMNOPQRSTUVWXYZZZZZZZZ9999999999'
  # auto refresh access_token with Client Credentials Grant when expired
  config.grant_type = :client_credentials
  config.access_token_auto_refresh = true
end
# da is DeviantArt::Client object

deviation = da.get_deviation('F98C2XXX-C6A8-XXXX-08F9-57CCXXXXX187')
deviation['title'] # => deviation's title
```

## How to Test

At the first, install gems:

```bash
$ bundle install
```

And you will run test with stub APIs:

```bash
$ bundle exec rake test
```

If you want to use **real** API in test, run this one:

```bash
$ bundle exec rake real
Input your browser command>
```

This prompt demands browser command for OAuth 2 authorization of deviantART.
After this, Rake task performs some steps:

- creates named pipe
- OAuth consumer server launches internal
- opens the browser with authorization page

```bash
$ bundle exec rake real
Input your browser command> firefox
Wrote "firefox" to test/browser_command
Boot Sinatra OAuth consumer...
Open browser for authorization
```

The OAuth consumer server writes access token to named pipe and terminates after you permit it on browser.
Rake task takes access token via named pipe.
The tests run with the access token.

```bash
--snip--
Open browser for authorization
Got access token!
# Running:

..............

Finished in 4.44s, 3.14159 runs/s, 11.4478 assertions/s.

14 runs, 51 assertions, 0 failures, 0 errors, 0 skips
```

The browser command is cached at `test/browser_command`, the access token is cached at `test/fixtures/authorization_code.json`.

## API

## Official API Document

[Developers - DeviantArt](https://www.deviantart.com/developers/)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Badges

[![Build Status](https://travis-ci.org/aycabta/deviantart.svg)](https://travis-ci.org/aycabta/deviantart)

