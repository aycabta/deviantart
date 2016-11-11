require 'helper'
require 'deviantart'

describe DeviantArt::Client::Collections do
  before(:all) do
    @da, @credentials = create_da
  end
  describe '#get_collections_folders' do
    before do
      @username = fixture('collections-input.json').json['username']
      @collections_folders = fixture('collections_folders.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/collections/folders`,
        da: @da,
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
        url: %r`^https://#{@da.host}/api/v1/oauth2/collections/#{@folderid}`,
        da: @da,
        body: @collections)
    end
    it 'requests the correct resource' do
      result = @da.get_collections(@folderid, username: @username)
      assert_instance_of(DeviantArt::Collections, result)
      assert_instance_of(Array, result.results)
      assert_instance_of(DeviantArt::Deviation, result.results.first)
    end
  end
end
