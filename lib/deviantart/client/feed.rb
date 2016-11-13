require 'deviantart/feed'
require 'deviantart/feed/home'

module DeviantArt
  class Client
    module Feed
      # Fetch Watch Feed
      def get_feed(mature_content: false, cursor: nil)
        params = {}
        params['cursor'] = cursor unless cursor.nil?
        params['mature_content'] = mature_content
        DeviantArt::Feed::Home.new(perform(:get, '/api/v1/oauth2/feed/home', params))
      end

      # TODO: home/{bucketid}, notifications, profile, settings, settings/update
    end
  end
end
