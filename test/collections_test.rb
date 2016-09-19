require 'helper'
require 'deviantart'

describe DeviantArt::Collections do
  before do
    @da, @client_credentials = create_da
  end
  describe '#get_collections_folders' do
    before do
      @username = fixture('collections-input.json').json['username']
      @collections_folders = fixture('collections_folders.json')
      if not real?
        stub_request(:get, %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/collections/folders`)
          .with(headers: { 'Authorization' => "Bearer #{@client_credentials.json['access_token']}" })
          .to_return(status: 200, body: @collections_folders, headers: { content_type: 'application/json; charset=utf-8' })
      end
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
      if not real?
        stub_request(:get, %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/collections/#{@folderid}`)
          .with(headers: { 'Authorization' => "Bearer #{@client_credentials.json['access_token']}" })
          .to_return(status: 200, body: @collections, headers: { content_type: 'application/json; charset=utf-8' })
      end
    end
    it 'requests the correct resource' do
      result = @da.get_collections(@folderid, username: @username)
      assert_equal(result.class, Hash)
      assert_includes(result, 'results')
    end
  end
end
