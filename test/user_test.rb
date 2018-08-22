require 'helper'
require 'deviantart'

class DeviantArt::Client::User::Test < Test::Unit::TestCase
  setup do
    @da, @credentials = create_da
  end
  sub_test_case '#get_profile' do
    setup do
      @profile = fixture('user_profile.json')
      @username = @profile.json['user']['username']
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/profile/#{@username}`,
        da: @da,
        body: @profile)
    end
    test 'requests the correct resource' do
      resp = @da.get_profile(@username)
      assert_instance_of(DeviantArt::User::Profile, resp)
      assert_instance_of(DeviantArt::User, resp.user)
      assert_equal("DeviantArt::User: #{@profile.json['user']['username']} #{@profile.json['user']['userid']}", resp.user.to_s)
      assert_instance_of(DeviantArt::Deviation, resp.profile_pic)
    end
  end
  sub_test_case '#update_profile' do
    setup do
      @profile = fixture('user_profile.json')
      @username = @profile.json['user']['username']
      @update_profile = fixture('user_update_profile.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/profile/#{@username}`,
        da: @da,
        body: @profile)
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/user/profile/update",
        da: @da,
        body: @update_profile)
    end
    test 'requests the correct resource' do
      original_profile = @da.get_profile(@username)
      resp = @da.update_profile(countryid: DeviantArt::CountryID::UnitedStates)
      assert_instance_of(DeviantArt::User::UpdateProfile, resp)
      updated_profile = @da.get_profile(@username)
      assert(updated_profile)
      resp = @da.update_profile(countryid: original_profile.countryid)
    end
  end
  sub_test_case '#update_profile' do
    setup do
      @profile = fixture('user_update_profile_with_no_parameters.json')
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/user/profile/update",
        da: @da,
        body: @profile,
        status_code: 400)
    end
    test 'with no parameters should fail' do
      resp = @da.update_profile
      assert_instance_of(DeviantArt::Error, resp)
    end
  end
  sub_test_case '#get_friends' do
    setup do
      @username = fixture('user_friends-input.json').json['username']
      @friends = fixture('user_friends.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends`,
        da: @da,
        body: @friends)
    end
    test 'requests the correct resource' do
      resp = @da.get_friends(@username)
      assert_instance_of(DeviantArt::User::Friends, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::User, resp.results.first.user)
    end
  end
  sub_test_case '#whois' do
    setup do
      @users = fixture('user_whois-input.json')
      @whois = fixture('user_whois.json')
      stub_da_request(
        method: :post,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/whois`,
        da: @da,
        body: @whois)
    end
    test 'requests the correct resource' do
      resp = @da.whois(@users.json)
      assert_instance_of(DeviantArt::User::Whois, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::User, resp.results.first)
    end
  end
  sub_test_case '#whoami' do
    setup do
      @whoami = fixture('user_whoami.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/user/whoami",
        da: @da,
        body: @whoami)
    end
    test 'requests the correct resource' do
      resp = @da.whoami
      assert_instance_of(DeviantArt::User, resp)
    end
  end
  sub_test_case '#search_friends' do
    setup do
      @friends_search = fixture('user_friends_search.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/search`,
        da: @da,
        body: @friends_search)
    end
    test 'requests the correct resource' do
      resp = @da.search_friends('n', username: 'Ray-kbys')
      assert_instance_of(DeviantArt::User::Friends::Search, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::User, resp.results.first)
    end
  end
  sub_test_case '#get_statuses' do
    setup do
      @statuses = fixture('user_statuses.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/statuses`,
        da: @da,
        body: @statuses)
    end
    test 'requests the correct resource' do
      resp = @da.get_statuses(@statuses.json['results'].first['author']['username'])
      assert_instance_of(DeviantArt::User::Statuses, resp)
      assert_instance_of(Array, resp.results)
      assert_boolean(resp.has_more)
      assert_instance_of(DeviantArt::Status, resp.results.first) unless resp.results.empty?
    end
  end
  sub_test_case '#get_status' do
    setup do
      @status = fixture('user_statuses_status.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/statuses/`,
        da: @da,
        body: @status)
    end
    test 'requests the correct resource' do
      resp = @da.get_status(@status.json['statusid'])
      assert_instance_of(DeviantArt::Status, resp)
      assert_equal("DeviantArt::Status: #{resp.body} by #{resp.author.username} #{resp.statusid}", resp.to_s)
    end
  end
  sub_test_case '#get_watchers' do
    setup do
      @watchers = fixture('user_watchers.json')
      @username = fixture('user_watchers-input.json').json['username']
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/watchers/`,
        da: @da,
        body: @watchers)
    end
    test 'requests the correct resource' do
      resp = @da.get_watchers(username: @username)
      assert_instance_of(DeviantArt::User::Watchers, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::User, resp.results.first.user)
    end
  end
  sub_test_case '#watch_status' do
    setup do
      @watching = fixture('user_friends_watching.json')
      @username = fixture('user_friends_watching-input.json').json['username']
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/watching/`,
        da: @da,
        body: @watching)
    end
    test 'requests the correct resource' do
      resp = @da.watch_status(@username)
      assert_instance_of(DeviantArt::User::Friends::Watching, resp)
      assert_boolean(resp.watching)
    end
  end
  sub_test_case '#watch_status' do
    setup do
      @watching_error = fixture('user_friends_watching-error_username_required.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/watching/`,
        da: @da,
        body: @watching_error,
        status_code: 400)
    end
    test 'failds with no username' do
      resp = @da.watch_status(nil)
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal('error', resp.status)
      assert_equal('invalid_request', resp.error)
      assert_equal('Request field validation failed.', resp.error_description)
      assert_equal('username is required', resp.error_details.username)
    end
  end
  sub_test_case '#watch' do
    setup do
      @username = fixture('user_friends_watch-input.json').json['username']
      @watch = fixture('user_friends_watch.json')
      stub_da_request(
        method: :post,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/watch/`,
        da: @da,
        body: @watch)
    end
    test 'requests the correct resource' do
      resp = @da.watch(@username)
      assert_instance_of(DeviantArt::User::Friends::Watch, resp)
      assert_equal(true, resp.success)
    end
  end
  sub_test_case '#watch' do
    setup do
      @watch = fixture('user_friends_watch-username_required.json')
      stub_da_request(
        method: :post,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/watch/`,
        da: @da,
        body: @watch,
        status_code: 400)
    end
    test 'requires username' do
      resp = @da.watch('')
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(400, resp.status_code)
      assert_equal('invalid_request', resp.error)
      assert_equal('username is required', resp.error_details.username)
      assert_equal('Request field validation failed.', resp.error_description)
      assert_equal('error', resp.status)
    end
  end
  sub_test_case '#watch' do
    setup do
      @username = fixture('user_friends_watch-user_not_found-input.json').json['username']
      @watch = fixture('user_friends_watch-user_not_found.json')
      stub_da_request(
        method: :post,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/watch/`,
        da: @da,
        body: @watch,
        status_code: 400)
    end
    test 'user not found' do
      resp = @da.watch(@username)
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(400, resp.status_code)
      assert_equal('invalid_request', resp.error)
      assert_equal('User not found.', resp.error_description)
      assert_equal(0, resp.error_code)
      assert_equal('error', resp.status)
    end
  end
  sub_test_case '#watch' do
    setup do
      @watch = fixture('user_friends_watch-user_own.json')
      @whoami = fixture('user_friends_watch-user_own-whoami.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/user/whoami?",
        da: @da,
        body: @whoami)
      stub_da_request(
        method: :post,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/watch/`,
        da: @da,
        body: @watch,
        status_code: 400)
    end
    test 'add you to your own friend' do
      resp = @da.watch(@da.whoami.username)
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(400, resp.status_code)
      assert_equal('invalid_request', resp.error)
      assert_equal('Failed to add friend - You can not add yourself to your own friends list.', resp.error_description)
      assert_equal(2, resp.error_code)
      assert_equal('error', resp.status)
    end
  end
  sub_test_case '#unwatch' do
    setup do
      @username = fixture('user_friends_unwatch-input.json').json['username']
      @unwatch = fixture('user_friends_unwatch.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/unwatch/`,
        da: @da,
        body: @unwatch)
    end
    test 'requests the correct resource' do
      resp = @da.unwatch(@username)
      assert_instance_of(DeviantArt::User::Friends::Unwatch, resp)
      assert_equal(true, resp.success)
    end
  end
  sub_test_case '#unwatch' do
    setup do
      @watch = fixture('user_friends_watch-username_required.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/unwatch/`,
        da: @da,
        body: @watch,
        status_code: 400)
    end
    test 'requires username' do
      resp = @da.unwatch('')
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(400, resp.status_code)
      assert_equal('invalid_request', resp.error)
      assert_equal('username is required', resp.error_details.username)
      assert_equal('Request field validation failed.', resp.error_description)
      assert_equal('error', resp.status)
    end
  end
  sub_test_case '#unwatch' do
    setup do
      @username = fixture('user_friends_unwatch-user_not_found-input.json').json['username']
      @watch = fixture('user_friends_unwatch-user_not_found.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/unwatch/`,
        da: @da,
        body: @watch,
        status_code: 400)
    end
    test 'user not found' do
      resp = @da.unwatch(@username)
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(400, resp.status_code)
      assert_equal('invalid_request', resp.error)
      assert_equal('User not found.', resp.error_description)
      assert_equal(0, resp.error_code)
      assert_equal('error', resp.status)
    end
  end
  sub_test_case '#watch_status after #watch' do
    setup do
      @username = fixture('user_friends_watch-input.json').json['username']
      @unwatch = fixture('user_friends_unwatch.json')
      @watch = fixture('user_friends_watch.json')
      @watching = fixture('user_friends_watching-true.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/unwatch/`,
        da: @da,
        body: @unwatch)
      stub_da_request(
        method: :post,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/watch/`,
        da: @da,
        body: @watch)
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/watching/`,
        da: @da,
        body: @watching)
      @da.unwatch(@username)
      @da.watch(@username)
    end
    test 'requests the correct resource' do
      resp = @da.watch_status(@username)
      assert_instance_of(DeviantArt::User::Friends::Watching, resp)
      assert_equal(true, resp.watching)
    end
  end
  sub_test_case '#watch_status after #unwatch' do
    setup do
      @username = fixture('user_friends_watch-input.json').json['username']
      @unwatch = fixture('user_friends_unwatch.json')
      @watch = fixture('user_friends_watch.json')
      @watching = fixture('user_friends_watching-false.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/unwatch/`,
        da: @da,
        body: @unwatch)
      stub_da_request(
        method: :post,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/watch/`,
        da: @da,
        body: @watch)
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/user/friends/watching/`,
        da: @da,
        body: @watching)
      @da.watch(@username)
      @da.unwatch(@username)
    end
    test 'requests the correct resource' do
      resp = @da.watch_status(@username)
      assert_instance_of(DeviantArt::User::Friends::Watching, resp)
      assert_equal(false, resp.watching)
    end
  end
  sub_test_case '#damntoken' do
    setup do
      @damntoken = fixture('user_damntoken.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/user/damntoken?",
        da: @da,
        body: @damntoken)
    end
    test 'requests the correct resource' do
      resp = @da.damntoken
      assert_instance_of(DeviantArt::User::DamnToken, resp)
      assert_instance_of(String, resp.damntoken)
    end
  end
end
