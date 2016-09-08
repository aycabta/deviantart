require 'helper'
require 'deviantart'

describe DeviantArt::Collections do
  before do
    @client_credentials = fixture('client_credentials.json')
    client_credentials_input = fixture('client_credentials-input.json')
    client_id = client_credentials_input.json['client_id']
    client_secret = client_credentials_input.json['client_secret']
    if not real?
      stub_request(:post, "https://#{DeviantArt::Client.host}/oauth2/token")
        .with(body: { 'client_id' => client_id.to_s, 'client_secret' => client_secret, 'grant_type' => 'client_credentials' }, headers: { 'Content-Type'=>'application/x-www-form-urlencoded' })
        .to_return(status: 200, body: @client_credentials, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
    end
    @da = DeviantArt.new do |config|
      config.client_id = client_id
      config.client_secret = client_secret
      config.grant_type = 'client_credentials'
      config.access_token_auto_refresh = true
    end
  end
  describe '#get_collections_folders' do
    before do
      @username = fixture('collections-input.json').json['username']
      @collections_folders = fixture('collections_folders.json')
      if not real?
        stub_request(:get, %r`https://#{DeviantArt::Client.host}/api/v1/oauth2/collections/folders`)
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
        stub_request(:get, "https://#{DeviantArt::Client.host}/api/v1/oauth2/collections/#{@folderid}")
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
