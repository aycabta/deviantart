require 'helper'
require 'deviantart'

describe DeviantArt::Client::User do
  before(:all) do
    @da, @credentials = create_da
  end
  describe '#get_profile' do
    before do
      @profile = fixture('user_profile.json')
      @username = @profile.json['user']['username']
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/profile/#{@username}`,
        da: @da,
        body: @profile)
    end
    it 'requests the correct resource' do
      resp = @da.get_profile(@username)
      assert_instance_of(DeviantArt::User::Profile, resp)
      assert_instance_of(DeviantArt::User, resp.user)
      assert_equal("DeviantArt::User: #{@profile.json['user']['username']} #{@profile.json['user']['userid']}", resp.user.inspect)
      assert_instance_of(DeviantArt::Deviation, resp.profile_pic)
    end
  end
  describe '#get_friends' do
    before do
      @username = fixture('user_friends-input.json').json['username']
      @friends = fixture('user_friends.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends`,
        da: @da,
        body: @friends)
    end
    it 'requests the correct resource' do
      resp = @da.get_friends(@username)
      assert_instance_of(DeviantArt::User::Friends, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::User, resp.results.first.user)
    end
  end
  describe '#whois' do
    before do
      @users = fixture('user_whois-input.json')
      @whois = fixture('user_whois.json')
      stub_da_request(
        method: :post,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/whois`,
        da: @da,
        body: @whois)
    end
    it 'requests the correct resource' do
      resp = @da.whois(@users.json)
      assert_instance_of(DeviantArt::User::Whois, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::User, resp.results.first)
    end
  end
  describe '#whoami' do
    before do
      @whoami = fixture('user_whoami.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/user/whoami",
        da: @da,
        body: @whoami)
    end
    it 'requests the correct resource' do
      resp = @da.whoami
      assert_instance_of(DeviantArt::User, resp)
    end
  end
  describe '#search_friends' do
    before do
      @friends_search = fixture('user_friends_search.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/search`,
        da: @da,
        body: @friends_search)
    end
    it 'requests the correct resource' do
      resp = @da.search_friends('n', username: 'Ray-kbys')
      assert_instance_of(DeviantArt::User::Friends::Search, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::User, resp.results.first)
    end
  end
  describe '#get_statuses' do
    before do
      @statuses = fixture('user_statuses.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/statuses`,
        da: @da,
        body: @statuses)
    end
    it 'requests the correct resource' do
      resp = @da.get_statuses(@statuses.json['results'].first['author']['username'])
      assert_instance_of(DeviantArt::User::Statuses, resp)
      assert_instance_of(Array, resp.results)
      assert_includes([true, false], resp.has_more)
      assert_instance_of(DeviantArt::Status, resp.results.first)
    end
  end
  describe '#get_status' do
    before do
      @status = fixture('user_statuses_status.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/statuses/`,
        da: @da,
        body: @status)
    end
    it 'requests the correct resource' do
      resp = @da.get_status(@status.json['statusid'])
      assert_instance_of(DeviantArt::Status, resp)
    end
  end
  describe '#get_watchers' do
    before do
      @watchers = fixture('user_watchers.json')
      @username = fixture('user_watchers-input.json').json['username']
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/watchers/`,
        da: @da,
        body: @watchers)
    end
    it 'requests the correct resource' do
      resp = @da.get_watchers(username: @username)
      assert_instance_of(DeviantArt::User::Watchers, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::User, resp.results.first.user)
    end
  end
end
