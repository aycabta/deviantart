require 'deviantart/user'
require 'deviantart/user/profile'
require 'deviantart/user/friends'
require 'deviantart/user/friends/search'
require 'deviantart/user/whois'
require 'deviantart/user/statuses'
require 'deviantart/user/watchers'
require 'deviantart/user/friends/watching'
require 'deviantart/user/friends/watch'
require 'deviantart/user/friends/unwatch'
require 'deviantart/user/damn_token'

module DeviantArt
  class Client
    module User
      # Get user profile information
      def get_profile(username, ext_collections: false, ext_galleries: false)
        params = {}
        params['ext_collections'] = ext_collections if ext_collections
        params['ext_galleries'] = ext_galleries if ext_galleries
        perform(DeviantArt::User::Profile, :get, "/api/v1/oauth2/user/profile/#{username.nil? ? '' : username}", params)
      end

      # Get the users list of friends
      def get_friends(username, offset: 0, limit: 10)
        params = {}
        params['offset'] = offset if offset != 0
        params['limit'] = limit if limit != 10
        perform(DeviantArt::User::Friends, :get, "/api/v1/oauth2/user/friends/#{username.nil? ? '' : username}", params)
      end

      # Fetch user info for given usernames
      def whois(users)
        params = { usernames: users.is_a?(Enumerable) ? users : [users] }
        perform(DeviantArt::User::Whois, :post, '/api/v1/oauth2/user/whois', params)
      end

      # Fetch user info of authenticated user
      def whoami
        perform(DeviantArt::User, :get, '/api/v1/oauth2/user/whoami?')
      end

      # Search friends by username
      def search_friends(query, username: nil)
        params = {}
        params['query'] = query
        params['username'] = username unless username.nil?
        perform(DeviantArt::User::Friends::Search, :get, '/api/v1/oauth2/user/friends/search', params)
      end

      # User Statuses
      def get_statuses(username, offset: 0, limit: 10, mature_content: true)
        params = {}
        params['username'] = username
        params['mature_content'] = mature_content
        params['offset'] = offset if offset != 0
        params['limit'] = limit if limit != 10
        perform(DeviantArt::User::Statuses, :get, '/api/v1/oauth2/user/statuses/', params)
      end

      # Fetch the status
      def get_status(statusid, mature_content: true)
        params = {}
        params['mature_content'] = mature_content
        perform(DeviantArt::Status, :get, "/api/v1/oauth2/user/statuses/#{statusid}", params)
      end

      # Get the user's list of watchers
      def get_watchers(username: nil, offset: 0, limit: 10)
        params = {}
        params['offset'] = offset if offset != 0
        params['limit'] = limit if limit != 10
        perform(DeviantArt::User::Watchers, :get, "/api/v1/oauth2/user/watchers/#{username.nil? ? '' : username}", params)
      end

      # Check if user is being watched by the given user
      def watch_status(username)
        perform(DeviantArt::User::Friends::Watching, :get, "/api/v1/oauth2/user/friends/watching/#{username.nil? ? '' : username}")
      end

      # Watch a user
      def watch(username, watch = {})
        watch_params = {}
        %w(friend deviations journals forum_threads critiques scraps activity collections).each do |p|
          if watch[p]
            watch_params[p] = true
          else
            watch_params[p] = false
          end
        end
        params = { watch: watch_params }
        perform(DeviantArt::User::Friends::Watch, :post, "/api/v1/oauth2/user/friends/watch/#{username.nil? ? '' : username}", params)
      end

      # Unwatch a user
      def unwatch(username)
        perform(DeviantArt::User::Friends::Unwatch, :get, "/api/v1/oauth2/user/friends/unwatch/#{username.nil? ? '' : username}")
      end

      # Retrieve the dAmn auth token required to connect to the dAmn servers
      def damntoken
        perform(DeviantArt::User::DamnToken, :get, '/api/v1/oauth2/user/damntoken?')
      end

      # TODO: damntoken, profile/update, statuses/post
    end
  end
end
