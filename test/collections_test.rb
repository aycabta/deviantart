require 'helper'
require 'deviantart'

describe DeviantArt::Collections do
  before(:all) do
    @da, @client_credentials = create_da
  end
  describe '#get_collections_folders' do
    before do
      @username = fixture('collections-input.json').json['username']
      @collections_folders = fixture('collections_folders.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/collections/folders`,
        client_credentials: @client_credentials,
        body: @collections_folders)
    end
    it 'requests the correct resource' do
      result = @da.get_collections_folders(username: @username)
      assert_equal(result.class, Hash)
      assert_includes(result, 'results')
    end
  end
  describe '#get_collections' do
    before do
      @username = fixture('collections-input.json').json['username']
      @folderid = fixture('collections_folders.json').json['results'].find { |c|
         c['name'] == 'tuturial'
      }['folderid']
      @collections = fixture('collections.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/collections/#{@folderid}`,
        client_credentials: @client_credentials,
        body: @collections)
    end
    it 'requests the correct resource' do
      result = @da.get_collections(@folderid, username: @username)
      assert_equal(result.class, Hash)
      assert_includes(result, 'results')
    end
  end
end
