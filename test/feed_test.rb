require 'helper'
require 'deviantart'

describe DeviantArt::Client::Feed do
  before(:all) do
    @da, @credentials = create_da
  end
  describe '#get_collections_folders' do
    before do
      @feed_home = fixture('feed_home.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/feed/home`,
        da: @da,
        body: @feed_home)
    end
    it 'requests the correct resource' do
      resp = @da.get_feed
      assert_instance_of(DeviantArt::Feed::Home, resp)
      assert_instance_of(Array, resp.items)
      assert_instance_of(DeviantArt::User, resp.items.first.by_user)
    end
  end
end
