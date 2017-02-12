require 'deviantart/gallery'
require 'deviantart/gallery/all'
require 'deviantart/gallery/folders'
require 'deviantart/gallery/folders/create'

module DeviantArt
  class Client
    module Gallery
      # Get the "all" view of a users gallery
      def get_gallery_all(username: nil, offset: 0, limit: 10)
        params = {}
        params['username'] = username unless username.nil?
        params['offset'] = offset if offset != 0
        params['limit'] = limit if limit != 10
        perform(DeviantArt::Gallery::All, :get, '/api/v1/oauth2/gallery/all', params)
      end

      # Fetch gallery folders
      def get_gallery_folders(username: nil, calculate_size: false, ext_preload: false, offset: 0, limit: 10)
        params = {}
        params['username'] = username unless username.nil?
        params['calculate_size'] = calculate_size if calculate_size
        params['ext_preload'] = ext_preload if ext_preload
        params['offset'] = offset if offset != 0
        params['limit'] = limit if limit != 10
        perform(DeviantArt::Gallery::Folders, :get, '/api/v1/oauth2/gallery/folders', params)
      end

      # Fetch gallery folder contents
      def get_gallery(username: nil, folderid: nil, mode: nil, offset: 0, limit: 10)
        params = {}
        params['username'] = username unless username.nil?
        params['mode'] = mode unless mode.nil?
        params['offset'] = offset if offset != 0
        params['limit'] = limit if limit != 10
        unless folderid.nil?
          path = "/api/v1/oauth2/gallery/#{folderid}"
        else
          path = '/api/v1/oauth2/gallery/'
        end
        perform(DeviantArt::Gallery, :get, path, params)
      end

      # Create new gallery folders.
      def create_gallery_folder(foldername)
        params = { folder: foldername }
        perform(DeviantArt::Gallery::Folders::Create, :post, '/api/v1/oauth2/gallery/folders/create', params)
      end

      # TODO: remove/{folderid}
    end
  end
end
