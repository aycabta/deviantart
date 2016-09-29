module DeviantArt
  module Feed
    # Fetch Watch Feed
    def get_feed(mature_content: false, cursor: nil)
      params = {}
      params['cursor'] = cursor unless cursor.nil?
      params['mature_content'] = mature_content
      perform(:get, '/api/v1/oauth2/feed/home', params)
    end
  end
end

