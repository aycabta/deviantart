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

deviation = da.get_deviation('F98C2XXX-C6A8-XXXX-08F9-57CCXXXXX187')
deviation['title'] # => deviation's title
```

## Official API Document

[Developers - DeviantArt](https://www.deviantart.com/developers/)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Badges

[![Build Status](https://travis-ci.org/aycabta/deviantart.svg)](https://travis-ci.org/aycabta/deviantart)

