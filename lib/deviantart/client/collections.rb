module DeviantArt
  class Client
    module Collections
      # Fetch collection folders
      def get_collections_folders(username: nil, calculate_size: false, ext_preload: false, offset: 0, limit: 10)
        params = {}
        params['username'] = username unless username.nil?
        params['calculate_size'] = calculate_size if calculate_size
        params['ext_preload'] = ext_preload if ext_preload
        params['offset'] = offset if offset != 0
        params['limit'] = limit if limit != 10
        perform(:get, '/api/v1/oauth2/collections/folders', params)
      end

      # Fetch collection folder contents
      def get_collections(folderid, username: nil, offset: 0, limit: 10)
        params = {}
        params['username'] = username unless username.nil?
        params['offset'] = offset if offset != 0
        params['limit'] = limit if limit != 10
        perform(:get, "/api/v1/oauth2/collections/#{folderid}", params)
      end

      # TODO: fave, folders/create, folders/remove/{folderid}, unfav
    end
  end
end

