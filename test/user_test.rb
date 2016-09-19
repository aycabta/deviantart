require 'helper'
require 'deviantart'

describe DeviantArt::User do
  before do
    @da, @client_credentials = create_da
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
  describe '#whois' do
    before do
      @users = fixture('user_whois-input.json')
      @whois = fixture('user_whois.json')
      if not real?
        stub_request(:post, %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/user/whois`)
          .with(headers: { 'Authorization' => "Bearer #{@client_credentials.json['access_token']}" })
          .to_return(status: 200, body: @whois, headers: { content_type: 'application/json; charset=utf-8' })
      end
    end
    it 'requests the correct resource' do
      result = @da.whois(@users.json)
      assert_equal(result.class, Hash)
      assert_includes(result, 'results')
    end
  end
end
