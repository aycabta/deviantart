require 'helper'
require 'deviantart'

describe DeviantArt::User do
  before do
    @client_credentials = fixture('client_credentials.json')
    client_credentials_input = fixture('client_credentials-input.json')
    client_id = client_credentials_input.json['client_id']
    client_secret = client_credentials_input.json['client_secret']
    if not real?
      stub_request(:post, "https://#{DeviantArt::Client.host}/oauth2/token")
        .with(body: { 'client_id' => client_id.to_s, 'client_secret' => client_secret, 'grant_type' => 'client_credentials' }, headers: { 'Content-Type'=>'application/x-www-form-urlencoded' })
        .to_return(status: 200, body: @client_credentials, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
    end
    @da = DeviantArt.new do |config|
      config.client_id = client_id
      config.client_secret = client_secret
      config.grant_type = 'client_credentials'
      config.access_token_auto_refresh = true
    end
  end
  describe '#get_profile' do
    before do
      @profile = fixture('user_profile.json')
      @username = @profile.json['user']['username']
      if not real?
        stub_request(:get, %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/user/profile/#{@username}`)
          .with(headers: { 'Authorization' => "Bearer #{@client_credentials.json['access_token']}" })
          .to_return(status: 200, body: @profile, headers: { content_type: 'application/json; charset=utf-8' })
      end
    end
    it 'requests the correct resource' do
      result = @da.get_profile(username: @username)
      assert_equal(result.class, Hash)
      assert_includes(result, 'user')
    end
  end
  describe '#get_friends' do
    before do
      @username = fixture('user_friends-input.json').json['username']
      @friends = fixture('user_friends.json')
      if not real?
        stub_request(:get, %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/user/friends`)
          .with(headers: { 'Authorization' => "Bearer #{@client_credentials.json['access_token']}" })
          .to_return(status: 200, body: @friends, headers: { content_type: 'application/json; charset=utf-8' })
      end
    end
    it 'requests the correct resource' do
      result = @da.get_friends(username: @username)
      assert_equal(result.class, Hash)
      assert_includes(result, 'results')
    end
  end
end
