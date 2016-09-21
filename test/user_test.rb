require 'helper'
require 'deviantart'

describe DeviantArt::User do
  before(:all) do
    @da, @credentials = create_da
  end
  describe '#get_profile' do
    before do
      @profile = fixture('user_profile.json')
      @username = @profile.json['user']['username']
      stub_da_request(
        method: :get,
        url: %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/user/profile/#{@username}`,
        da: @da,
        body: @profile)
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
      stub_da_request(
        method: :get,
        url: %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/user/friends`,
        da: @da,
        body: @friends)
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
      stub_da_request(
        method: :post,
        url: %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/user/whois`,
        da: @da,
        body: @whois)
    end
    it 'requests the correct resource' do
      result = @da.whois(@users.json)
      assert_equal(result.class, Hash)
      assert_includes(result, 'results')
    end
  end
end
