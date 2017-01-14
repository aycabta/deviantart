$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'deviantart'

require 'minitest/autorun'
require 'webmock/minitest'
require 'json'

def real?
  ENV.include?('REAL') && !ENV['REAL'].nil? && !ENV['REAL'].empty?
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
    stub_request(:get, "https://#{DeviantArt::Client.default_host}/oauth2/token")
      .with(body: { 'client_id' => client_id.to_s, 'client_secret' => client_secret, 'grant_type' => 'refresh_token' },
            headers: { 'Content-Type'=>'application/x-www-form-urlencoded' })
      .to_return(status: 200,
                 body: credentials.json['authorization_code'].to_s,
                 headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
  end
  da = DeviantArt::Client.new do |config|
    config.client_id = client_id
    config.client_secret = client_secret
    config.grant_type = :authorization_code
    config.access_token = access_token
    config.refresh_token = refresh_token
    config.access_token_auto_refresh = true
  end
  if real?
    da.on_refresh_authorization_code do |new_access_token, new_refresh_token|
      authorization_code_file = 'test/fixtures/authorization_code.json'
      authorization_code = nil
      open(authorization_code_file, 'r') do |f|
        authorization_code = JSON.parse(f.read)
      end
      File.unlink(authorization_code_file)
      authorization_code['credentials']['token'] = new_access_token
      authorization_code['credentials']['refresh_token'] = new_refresh_token
      open(authorization_code_file, 'w') do |f|
        f.write(JSON.pretty_generate(authorization_code))
      end
    end
  end
  [da, credentials]
end

def stub_da_request(method: :get, url: "https://#{DeviantArt::Client.host}/api/v1/oauth2/", da: nil, body: nil, status_code: 200, headers: {})
  unless real?
    request = stub_request(method, url)
    built_headers = {}
    if !da.nil?
      built_headers = built_headers.merge({ 'Authorization' => "Bearer #{da.access_token}" })
    end
    response_parameters = {}
    if !body.nil?
      response_parameters[:body] = body
    end
    response_parameters[:status] = status_code
    response_parameters[:headers] = { content_type: 'application/json; charset=utf-8' }
    built_headers = built_headers.merge(headers)
    request = request.with(headers: built_headers) unless built_headers.empty?
    request.to_return(response_parameters)
    request
  else
    nil
  end
end

WebMock.allow_net_connect! if real?
