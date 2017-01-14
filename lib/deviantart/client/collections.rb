require 'deviantart/collections'
require 'deviantart/collections/folders'
require 'deviantart/collections/fave'
require 'deviantart/collections/unfave'

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
        perform(DeviantArt::Collections::Folders, :get, '/api/v1/oauth2/collections/folders', params)
      end

      # Fetch collection folder contents
      def get_collections(folderid, username: nil, offset: 0, limit: 10)
        params = {}
        params['username'] = username unless username.nil?
        params['offset'] = offset if offset != 0
        params['limit'] = limit if limit != 10
        perform(DeviantArt::Collections, :get, "/api/v1/oauth2/collections/#{folderid}", params)
      end

      # Add deviation to favourites
      def fave(deviationid, folderid: nil)
        params = { deviationid: deviationid }
        params['folderid'] = folderid unless folderid.nil?
        perform(DeviantArt::Collections::Fave, :post, '/api/v1/oauth2/collections/fave', params)
      end

      #   Add deviation to favourites
      def unfave(deviationid, folderid: nil)
        params = { deviationid: deviationid }
        params['folderid'] = folderid unless folderid.nil?
        perform(DeviantArt::Collections::Unfave, :post, '/api/v1/oauth2/collections/unfave', params)
      end

      # TODO: folders/create, folders/remove/{folderid}
    end
  end
end
