$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'deviantart'

require 'minitest/autorun'
require 'webmock/minitest'
require 'json'

def real?
  ENV.include?('REAL')
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture(file)
  data = File.new(File.join(fixture_path, file)).read
  data.instance_eval do
    def json
      @json ||= JSON.parse(self)
    end
  end
  data
end

def create_da
  # TODO: rename client_credentials with credentials
  client_credentials = fixture('client_credentials.json')
  client_credentials_input = fixture('client_credentials-input.json')
  client_id = client_credentials_input.json['authorization_code']['client_id']
  client_secret = client_credentials_input.json['authorization_code']['client_secret']
  access_token = client_credentials_input.json['authorization_code']['access_token']
  refresh_token = client_credentials_input.json['authorization_code']['refresh_token']
  if not real?
    stub_request(:post, "https://#{DeviantArt::Client.host}/oauth2/token")
    .with(body: { 'client_id' => client_id.to_s, 'client_secret' => client_secret, 'grant_type' => 'refresh_token' }, headers: { 'Content-Type'=>'application/x-www-form-urlencoded' })
    .to_return(status: 200, body: client_credentials.json['authorization_code'].to_s, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
  end
  da = DeviantArt.new do |config|
    config.client_id = client_id
    config.client_secret = client_secret
    config.grant_type = :authorization_code
    config.access_token = access_token
    config.refresh_token = refresh_token
    config.access_token_auto_refresh = true
  end
  [da, client_credentials]
end

def stub_da_request(method: :get, url: "https://#{DeviantArt::Client.host}/api/v1/oauth2/", client_credentials: nil, body: nil)
  if not real?
    stub_request(method, url)
      .with(headers: { 'Authorization' => "Bearer #{client_credentials.json['authorization_code']['access_token']}" })
      .to_return(status: 200, body: body, headers: { content_type: 'application/json; charset=utf-8' })
  end
end

WebMock.allow_net_connect! if real?
