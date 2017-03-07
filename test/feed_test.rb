require 'helper'
require 'deviantart'

class DeviantArt::Client::Feed::Test < Test::Unit::TestCase
  setup do
    @da, @credentials = create_da
  end
  sub_test_case '#feed_home' do
    setup do
      @feed_home = fixture('feed_home.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/feed/home`,
        da: @da,
        body: @feed_home)
    end
    test 'requests the correct resource' do
      resp = @da.feed_home
      assert_instance_of(DeviantArt::Feed::Home, resp)
      assert_instance_of(Array, resp.items)
      assert_instance_of(DeviantArt::User, resp.items.first.by_user)
    end
  end
  sub_test_case '#feed_profile' do
    setup do
      @feed_profile = fixture('feed_profile.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/feed/profile`,
        da: @da,
        body: @feed_profile)
    end
    test 'requests the correct resource' do
      resp = @da.feed_profile
      assert_instance_of(DeviantArt::Feed::Profile, resp)
      assert_instance_of(Array, resp.items)
      assert_instance_of(DeviantArt::User, resp.items.first.by_user)
    end
  end
end
