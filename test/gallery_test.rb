require 'helper'
require 'deviantart'

describe DeviantArt::Client::Gallery do
  before(:all) do
    @da, @credentials = create_da
  end
  describe '#get_gallery_all' do
    before do
      @username = fixture('gallery-input.json').json['username']
      @gallery_all = fixture('gallery_all.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/gallery/all`,
        da: @da,
        body: @gallery_all)
    end
    it 'requests the correct resource' do
      result = @da.get_gallery_all(username: @username)
      assert_instance_of(DeviantArt::Gallery::All, result)
      assert_instance_of(Array, result.results)
      assert_instance_of(DeviantArt::Deviation, result.results.first)
    end
  end
  describe '#get_gallery_folders' do
    before do
      @username = fixture('gallery-input.json').json['username']
      @gallery_folders = fixture('gallery_folders.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/gallery/folders`,
        da: @da,
        body: @gallery_folders)
    end
    it 'requests the correct resource' do
      result = @da.get_gallery_folders(username: @username, calculate_size: true, ext_preload: true)
      assert_instance_of(DeviantArt::Gallery::Folders, result)
      assert_instance_of(Array, result.results)
      assert_instance_of(DeviantArt::Deviation, result.results.first.deviations.first)
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
        url: %r`^https://#{@da.host}/api/v1/oauth2/gallery/#{@folderid}`,
        da: @da,
        body: @gallery)
    end
    it 'requests the correct resource' do
      result = @da.get_gallery(username: @username, folderid: @folderid)
      assert_instance_of(DeviantArt::Gallery, result)
      assert_instance_of(Array, result.results)
      assert_instance_of(DeviantArt::Deviation, result.results.first)
    end
  end
end
