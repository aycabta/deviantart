require 'helper'
require 'deviantart'
require 'deviantart/authorization_code'
require 'deviantart/authorization_code/refresh_token'

describe DeviantArt::Client do
  describe '#refresh_access_token' do
    before do
      @da, @credentials = create_da
      @refresh_authorization_code = fixture('refresh_authorization_code.json')
      stub_da_request(
        method: :post,
        url: "https://#{DeviantArt::Client.default_host}/oauth2/token",
        status_code: 200,
        body: @refresh_authorization_code)
    end
    it 'requests the correct resource' do
      @da.access_token = nil
      assert_nil(@da.access_token)
      resp = @da.refresh_access_token
      assert(!@da.access_token.nil?)
      assert_instance_of(DeviantArt::AuthorizationCode::RefreshToken, resp)
      assert_equal('Bearer', resp.token_type)
      assert_equal(3600, resp.expires_in)
      assert_equal('success', resp.status)
    end
  end
  describe '#on_refresh_access_token and #on_refresh_authorization_code with Authorization Code Grant' do
    before do
      @da, @credentials = create_da
      @refresh_authorization_code = fixture('refresh_authorization_code.json')
      stub_da_request(
        method: :post,
        url: "https://#{DeviantArt::Client.default_host}/oauth2/token",
        status_code: 200,
        body: @refresh_authorization_code)
    end
    it 'requests the correct resource' do
      @da.access_token = nil
      @da.on_refresh_access_token do |access_token|
        assert_instance_of(String, access_token)
      end
      @da.on_refresh_authorization_code do |access_token, refresh_token|
        assert_instance_of(String, access_token)
        assert_instance_of(String, refresh_token)
      end
      @da.refresh_access_token
    end
  end
  describe '#on_refresh_access_token with Client Credentials Grant' do
    before do
      credentials_input = fixture('credentials-input.json')
      @da = DeviantArt::Client.new do |config|
        config.client_id = credentials_input.json['client_credentials']['client_id']
        config.client_secret = credentials_input.json['client_credentials']['client_secret']
        config.grant_type = :client_credentials
        config.access_token_auto_refresh = true
      end
      @refresh_client_credentials = fixture('refresh_client_credentials.json')
      stub_da_request(
        method: :post,
        url: "https://#{DeviantArt::Client.default_host}/oauth2/token",
        status_code: 200,
        body: @refresh_client_credentials)
    end
    it 'requests the correct resource' do
      @da.access_token = nil
      @da.on_refresh_access_token do |access_token|
        assert_instance_of(String, access_token)
      end
      @da.refresh_access_token
    end
  end
end
