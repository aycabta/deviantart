require 'helper'
require 'deviantart'
require 'deviantart/version'

describe DeviantArt::Deviation do
  before do
    @client_credentials = fixture('client_credentials.json')
    client_id = 9999
    client_secret = 'LMNOPQRSTUVWXYZZZZZZZZ9999999999'
    stub_request(:post, "https://#{DeviantArt::Client.host}/oauth2/token")
      .with(body: { 'client_id' => client_id.to_s, 'client_secret' => client_secret, 'grant_type' => 'client_credentials' }, headers: { 'Content-Type'=>'application/x-www-form-urlencoded' })
      .to_return(status: 200, body: @client_credentials, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
    @da = DeviantArt.new do |config|
      config.client_id = client_id
      config.client_secret = client_secret
      config.grant_type = 'client_credentials'
      config.access_token_auto_refresh = true
    end
  end
  describe '#get_deviation' do
    before do
      @deviation = fixture('deviation.json')
      stub_request(:get, "https://#{DeviantArt::Client.host}/api/v1/oauth2/deviation/#{@deviation.json['deviationid']}")
        .with(headers: { 'Authorization' => "Bearer #{@client_credentials.json['access_token']}" })
        .to_return(status: 200, body: @deviation, headers: { content_type: 'application/json; charset=utf-8' })
    end
    it 'requests the correct resource' do
      result = @da.get_deviation(@deviation.json['deviationid'])
      assert_equal(result.class, Hash)
      assert_equal(result['deviationid'], @deviation.json['deviationid'])
    end
  end
  describe '#get_deviation_content' do
    before do
      @deviationid = fixture('deviation_content-input.json').json['deviationid']
      @deviation_content = fixture('deviation_content.json')
      stub_request(:get, %r`https://#{DeviantArt::Client.host}/api/v1/oauth2/deviation/content\?deviationid=.*`)
        .with(headers: { 'Authorization' => "Bearer #{@client_credentials.json['access_token']}" })
        .to_return(status: 200, body: @deviation_content, headers: { content_type: 'application/json; charset=utf-8' })
    end
    it 'requests the correct resource' do
      result = @da.get_deviation_content(@deviationid)
      assert_equal(result.class, Hash)
      assert_includes(result, 'html')
    end
  end
end
