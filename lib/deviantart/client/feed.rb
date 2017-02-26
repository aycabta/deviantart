require 'deviantart/feed'
require 'deviantart/feed/home'
require 'deviantart/feed/profile'

module DeviantArt
  class Client
    module Feed
      # Fetch Watch Feed
      def feed_home(mature_content: false, cursor: nil)
        params = {}
        params['cursor'] = cursor unless cursor.nil?
        params['mature_content'] = mature_content
        perform(DeviantArt::Feed::Home, :get, '/api/v1/oauth2/feed/home', params)
      end

      # Fetch Profile Feed
      def profile(cursor: nil)
        params = {}
        params['cursor'] = cursor unless cursor.nil?
        perform(DeviantArt::Feed::Profile, :get, '/api/v1/oauth2/feed/profile', params)
      end

      # TODO: home/{bucketid}, notifications, profile, settings, settings/update
    end
  end
end
