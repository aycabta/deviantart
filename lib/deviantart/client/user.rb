require 'deviantart/user'
require 'deviantart/user/profile'
require 'deviantart/user/friends'
require 'deviantart/user/friends/search'
require 'deviantart/user/whois'

module DeviantArt
  class Client
    module User
      # Get user profile information
      def get_profile(username, ext_collections: false, ext_galleries: false)
        params = {}
        params['ext_collections'] = ext_collections if ext_collections
        params['ext_galleries'] = ext_galleries if ext_galleries
        DeviantArt::User::Profile.new(perform(:get, "/api/v1/oauth2/user/profile/#{username.nil? ? '' : username}", params))
      end

      # Get the users list of friends
      def get_friends(username, offset: 0, limit: 10)
        params = {}
        params['offset'] = offset if offset != 0
        params['limit'] = limit if limit != 10
        DeviantArt::User::Friends.new(perform(:get, "/api/v1/oauth2/user/friends/#{username.nil? ? '' : username}", params))
      end

      # Fetch user info for given usernames
      def whois(users)
        params = { usernames: users.is_a?(Enumerable) ? users : [users] }
        DeviantArt::User::Whois.new(perform(:post, '/api/v1/oauth2/user/whois', params))
      end

      # Fetch user info of authenticated user
      def whoami
        DeviantArt::User.new(perform(:get, '/api/v1/oauth2/user/whoami?'))
      end

      # Search friends by username
      def search_friends(query, username: nil)
        params = {}
        params['query'] = query
        params['username'] = username unless username.nil?
        DeviantArt::User::Friends::Search.new(perform(:get, '/api/v1/oauth2/user/friends/search', params))
      end

      # User Statuses
      def get_statuses(username, offset: 0, limit: 10, mature_content: true)
        params = {}
        params['username'] = username
        params['mature_content'] = mature_content
        params['offset'] = offset if offset != 0
        params['limit'] = limit if limit != 10
        perform(:get, '/api/v1/oauth2/user/statuses/', params)
      end

      # Fetch the status
      def get_status(statusid, mature_content: true)
        params = {}
        params['mature_content'] = mature_content
        perform(:get, "/api/v1/oauth2/user/statuses/#{statusid}", params)
      end

      # Get the user's list of watchers
      def get_watchers(username: nil, offset: 0, limit: 10)
        params = {}
        params['offset'] = offset if offset != 0
        params['limit'] = limit if limit != 10
        perform(:get, "/api/v1/oauth2/user/watchers/#{username.nil? ? '' : username}", params)
      end

      # TODO: damntoken, friends/unwatch/{username}, friends/watch/{username}, friends/watching/{username}, profile/update, statuses/post
    end
  end
end
