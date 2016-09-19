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
      if not real?
        stub_request(:get, %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/gallery/all`)
          .with(headers: { 'Authorization' => "Bearer #{@client_credentials.json['access_token']}" })
          .to_return(status: 200, body: @gallery_all, headers: { content_type: 'application/json; charset=utf-8' })
      end
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
      if not real?
        stub_request(:get, %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/gallery/folders`)
          .with(headers: { 'Authorization' => "Bearer #{@client_credentials.json['access_token']}" })
          .to_return(status: 200, body: @gallery_folders, headers: { content_type: 'application/json; charset=utf-8' })
      end
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
      if not real?
        stub_request(:get, %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/gallery/#{@folderid}`)
          .with(headers: { 'Authorization' => "Bearer #{@client_credentials.json['access_token']}" })
          .to_return(status: 200, body: @gallery, headers: { content_type: 'application/json; charset=utf-8' })
      end
    end
    it 'requests the correct resource' do
      result = @da.get_gallery(username: @username, folderid: @folderid)
      assert_equal(result.class, Hash)
      assert_includes(result, 'results')
    end
  end
end
