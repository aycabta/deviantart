module DeviantArt
  module Gallery
    def get_gallery_all(username: nil, offset: 0, limit: 10)
      params = {}
      params['username'] = username if !username.nil?
      params['offset'] = offset if offset != 0
      params['limit'] = limit if limit != 10
      perform(:get, "/api/v1/oauth2/gallery/all", params)
    end

    def get_gallery_folders(username: nil, calculate_size: false, ext_preload: false, offset: 0, limit: 10)
      params = {}
      params['username'] = username if !username.nil?
      params['calculate_size'] = calculate_size if calculate_size
      params['ext_preload'] = ext_preload if ext_preload
      params['offset'] = offset if offset != 0
      params['limit'] = limit if limit != 10
      perform(:get, "/api/v1/oauth2/gallery/folders", params)
    end

    def get_gallery(username: nil, folderid: nil, mode: nil, offset: 0, limit: 10)
      params = {}
      params['username'] = username if !username.nil?
      params['mode'] = mode if !mode.nil?
      params['offset'] = offset if offset != 0
      params['limit'] = limit if limit != 10
      unless folderid.nil?
        path = "/api/v1/oauth2/gallery/#{folderid}"
      else
        path = "/api/v1/oauth2/gallery/"
      end
      perform(:get, path, params)
    end
  end
end

