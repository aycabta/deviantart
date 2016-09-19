require 'helper'
require 'deviantart'

describe DeviantArt::Gallery do
  before do
    @da, @client_credentials = create_da
  end
  describe '#get_gallery_all' do
    before do
      @username = fixture('gallery-input.json').json['username']
      @gallery_all = fixture('gallery_all.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/gallery/all`,
        client_credentials: @client_credentials,
        body: @gallery_all)
    end
    it 'requests the correct resource' do
      result = @da.get_gallery_all(username: @username)
      assert_equal(result.class, Hash)
      assert_includes(result, 'results')
    end
  end
  describe '#get_gallery_folders' do
    before do
      @username = fixture('gallery-input.json').json['username']
      @gallery_folders = fixture('gallery_folders.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/gallery/folders`,
        client_credentials: @client_credentials,
        body: @gallery_folders)
    end
    it 'requests the correct resource' do
      result = @da.get_gallery_folders(username: @username)
      assert_equal(result.class, Hash)
      assert_includes(result, 'results')
    end
  end
  describe '#get_gallery' do
    before do
      gallery_input = fixture('gallery-input.json').json
      @username = gallery_input['username']
      @folderid = gallery_input['folderid']
      @gallery = fixture('gallery.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/gallery/#{@folderid}`,
        client_credentials: @client_credentials,
        body: @gallery)
    end
    it 'requests the correct resource' do
      result = @da.get_gallery(username: @username, folderid: @folderid)
      assert_equal(result.class, Hash)
      assert_includes(result, 'results')
    end
  end
end
