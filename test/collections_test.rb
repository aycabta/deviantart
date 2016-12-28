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
      resp = @da.get_collections_folders(username: @username, ext_preload: true)
      assert_instance_of(DeviantArt::Collections::Folders, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::Deviation, resp.results.first.deviations.first)
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
      resp = @da.get_collections(@folderid, username: @username)
      assert_instance_of(DeviantArt::Collections, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::Deviation, resp.results.first)
    end
  end
  describe '#fave and #unfave' do
    before do
      @deviationid = fixture('fave-input.json').json['deviationid']
      @fave = fixture('fave.json')
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/fave",
        da: @da,
        body: @fave)
      stub_da_request(
        method: :post,
        url: "https://#{@da.host}/api/v1/oauth2/collections/unfave",
        da: @da,
        body: @fave)
    end
    it 'requests the correct resource' do
      resp = @da.fave(@deviationid)
      assert_instance_of(DeviantArt::Collections::Fave, resp)
      assert_includes([true, false], resp.success)
      assert_instance_of(Fixnum, resp.favourites)
      resp = @da.unfave(@deviationid)
      assert_instance_of(DeviantArt::Collections::Unfave, resp)
      assert_includes([true, false], resp.success)
      assert_instance_of(Fixnum, resp.favourites)
    end
  end
end
