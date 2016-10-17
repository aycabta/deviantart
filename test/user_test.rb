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
      result = @da.get_profile(@username)
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
  describe '#whoami' do
    before do
      @whoami = fixture('user_whoami.json')
      stub_da_request(
        method: :get,
        url: "https://#{DeviantArt::Client.host}/api/v1/oauth2/user/whoami",
        da: @da,
        body: @whoami)
    end
    it 'requests the correct resource' do
      result = @da.whoami
      assert_equal(result.class, Hash)
      assert_includes(result, 'userid')
    end
  end
  describe '#search_friends' do
    before do
      @friends_search = fixture('user_friends_search.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/user/friends/search`,
        da: @da,
        body: @friends_search)
    end
    it 'requests the correct resource' do
      result = @da.search_friends('n', username: 'Ray-kbys')
      assert_equal(result.class, Hash)
      assert_includes(result, 'results')
    end
  end
end
