module DeviantArt
  module User
    def get_profile(username: nil, ext_collections: false, ext_galleries: false)
      params = {}
      params['ext_collections'] = ext_collections if ext_collections
      params['ext_galleries'] = ext_galleries if ext_galleries
      perform(:get, "/api/v1/oauth2/user/profile/#{username.nil? ? '' : username}", params)
    end
  end
end

