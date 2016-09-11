require 'helper'
require 'deviantart'

describe DeviantArt::Deviation do
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
  describe '#get_deviation' do
    before do
      @deviation = fixture('deviation.json')
      if not real?
        stub_request(:get, "https://#{DeviantArt::Client.host}/api/v1/oauth2/deviation/#{@deviation.json['deviationid']}")
        .with(headers: { 'Authorization' => "Bearer #{@client_credentials.json['access_token']}" })
        .to_return(status: 200, body: @deviation, headers: { content_type: 'application/json; charset=utf-8' })
      end
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
      if not real?
        stub_request(:get, %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/deviation/content\?deviationid=.*`)
          .with(headers: { 'Authorization' => "Bearer #{@client_credentials.json['access_token']}" })
          .to_return(status: 200, body: @deviation_content, headers: { content_type: 'application/json; charset=utf-8' })
      end
    end
    it 'requests the correct resource' do
      result = @da.get_deviation_content(@deviationid)
      assert_equal(result.class, Hash)
      assert_includes(result, 'html')
      assert_includes(result, 'css')
      assert_includes(result, 'css_fonts')
    end
  end
  describe '#get_deviation_whofaved' do
    before do
      @deviationid = fixture('deviation_whofaved-input.json').json['deviationid']
      @deviation_whofaved = fixture('deviation_whofaved.json')
      if not real?
        stub_request(:get, %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/deviation/whofaved\?deviationid=.*`)
          .with(headers: { 'Authorization' => "Bearer #{@client_credentials.json['access_token']}" })
          .to_return(status: 200, body: @deviation_whofaved, headers: { content_type: 'application/json; charset=utf-8' })
      end
    end
    it 'requests the correct resource' do
      result = @da.get_deviation_whofaved(@deviationid)
      assert_equal(result.class, Hash)
      assert_includes(result, 'results')
    end
  end
  describe '#download_deviation' do
    before do
      @deviationid = fixture('deviation_download-input.json').json['deviationid']
      @deviation_download = fixture('deviation_download.json')
      if not real?
        stub_request(:get, %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/deviation/download/#{@deviationid}`)
          .with(headers: { 'Authorization' => "Bearer #{@client_credentials.json['access_token']}" })
          .to_return(status: 200, body: @deviation_download, headers: { content_type: 'application/json; charset=utf-8' })
      end
    end
    it 'requests the correct resource' do
      result = @da.download_deviation(@deviationid)
      assert_equal(result.class, Hash)
      assert_includes(result, 'src')
      assert_includes(result, 'filesize')
      assert_includes(result, 'width')
      assert_includes(result, 'height')
    end
  end
end
