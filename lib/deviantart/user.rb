module DeviantArt
  module User
    def get_profile(username: nil, ext_collections: false, ext_galleries: false)
      params = {}
      params['ext_collections'] = ext_collections if ext_collections
      params['ext_galleries'] = ext_galleries if ext_galleries
      perform(:get, "/api/v1/oauth2/user/profile/#{username.nil? ? '' : username}", params)
    end

    def get_friends(username: nil, offset: 0, limit: 10)
      params = {}
      params['offset'] = offset if offset != 0
      params['limit'] = limit if limit != 10
      perform(:get, "/api/v1/oauth2/user/friends/#{username.nil? ? '' : username}", params)
    end
  end
end

