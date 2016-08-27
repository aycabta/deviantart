# deviantART API library

## Installation

    $ gem install deviantart

## Usage

```ruby
da = DeviantArt.new do |config|
  config.client_id = 9999
  config.client_secret = 'LMNOPQRSTUVWXYZZZZZZZZ9999999999'
  # auto refresh access_token with Client Credentials Grant when expired
  config.client_credentials_auto_refresh = true
end

deviation = da.get_deviation('F98C2XXX-C6A8-XXXX-08F9-57CCXXXXX187')
deviation['title'] # => deviation's title
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

