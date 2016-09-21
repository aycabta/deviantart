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
  credentials = fixture('credentials.json')
  if real?
    credentials_input = fixture('credentials-input.json')
    client_id = credentials_input.json['authorization_code']['client_id']
    client_secret = credentials_input.json['authorization_code']['client_secret']
    credentials_input = fixture('authorization_code.json')
    access_token = credentials_input.json['credentials']['token']
    refresh_token = credentials_input.json['credentials']['refresh_token']
  else
    credentials_input = fixture('credentials-input.json')
    client_id = credentials_input.json['authorization_code']['client_id']
    client_secret = credentials_input.json['authorization_code']['client_secret']
    access_token = credentials_input.json['authorization_code']['access_token']
    refresh_token = credentials_input.json['authorization_code']['refresh_token']
    stub_request(:get, "https://#{DeviantArt::Client.host}/oauth2/token")
      .with(body: { 'client_id' => client_id.to_s, 'client_secret' => client_secret, 'grant_type' => 'refresh_token' },
            headers: { 'Content-Type'=>'application/x-www-form-urlencoded' })
      .to_return(status: 200,
                 body: credentials.json['authorization_code'].to_s,
                 headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
  end
  da = DeviantArt.new do |config|
    config.client_id = client_id
    config.client_secret = client_secret
    config.grant_type = :authorization_code
    config.access_token = access_token
    config.refresh_token = refresh_token
    config.access_token_auto_refresh = true
  end
  [da, credentials]
end

def stub_da_request(method: :get, url: "https://#{DeviantArt::Client.host}/api/v1/oauth2/", da: nil, body: nil)
  if not real?
    stub_request(method, url)
      .with(headers: { 'Authorization' => "Bearer #{da.access_token}" })
      .to_return(status: 200, body: body, headers: { content_type: 'application/json; charset=utf-8' })
  end
end

WebMock.allow_net_connect! if real?
