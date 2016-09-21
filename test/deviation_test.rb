require 'helper'
require 'deviantart'

describe DeviantArt::Deviation do
  before(:all) do
    @da, @credentials = create_da
  end
  describe '#get_deviation' do
    before do
      @deviation = fixture('deviation.json')
      stub_da_request(
        method: :get,
        url: "https://#{DeviantArt::Client.host}/api/v1/oauth2/deviation/#{@deviation.json['deviationid']}",
        credentials: @credentials,
        body: @deviation)
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
      stub_da_request(
        method: :get,
        url: %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/deviation/content\?deviationid=.*`,
        credentials: @credentials,
        body: @deviation_content)
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
      stub_da_request(
        method: :get,
        url: %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/deviation/whofaved\?deviationid=.*`,
        credentials: @credentials,
        body: @deviation_whofaved)
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
      stub_da_request(
        method: :get,
        url: %r`^https://#{DeviantArt::Client.host}/api/v1/oauth2/deviation/download/#{@deviationid}`,
        credentials: @credentials,
        body: @deviation_download)
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
