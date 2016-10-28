require 'helper'
require 'deviantart'

describe DeviantArt::Client::Deviation do
  before(:all) do
    @da, @credentials = create_da
  end
  describe '#get_deviation' do
    before do
      @deviation = fixture('deviation.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/deviation/#{@deviation.json['deviationid']}",
        da: @da,
        body: @deviation)
    end
    it 'requests the correct resource' do
      result = @da.get_deviation(@deviation.json['deviationid'])
      assert_equal(result.class, DeviantArt::Deviation)
      assert_equal(result.thumbs.class, Array)
      assert_equal(result.thumbs.first.width.class, Fixnum)
      assert_equal(result.deviationid, @deviation.json['deviationid'])
    end
  end
  describe '#get_deviation_content' do
    before do
      @deviationid = fixture('deviation_content-input.json').json['deviationid']
      @deviation_content = fixture('deviation_content.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/deviation/content\?deviationid=.*`,
        da: @da,
        body: @deviation_content)
    end
    it 'requests the correct resource' do
      result = @da.get_deviation_content(@deviationid)
      assert_equal(result.class, DeviantArt::Deviation::Content)
      assert_respond_to(result, 'html')
      assert_respond_to(result, 'css')
      assert_respond_to(result, 'css_fonts')
    end
  end
  describe '#get_deviation_whofaved' do
    before do
      @deviationid = fixture('deviation_whofaved-input.json').json['deviationid']
      @deviation_whofaved = fixture('deviation_whofaved.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/deviation/whofaved\?deviationid=.*`,
        da: @da,
        body: @deviation_whofaved)
    end
    it 'requests the correct resource' do
      result = @da.get_deviation_whofaved(@deviationid)
      assert_equal(result.class, DeviantArt::Deviation::WhoFaved)
      assert_respond_to(result, 'results')
    end
  end
  describe '#download_deviation' do
    before do
      @deviationid = fixture('deviation_download-input.json').json['deviationid']
      @deviation_download = fixture('deviation_download.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/deviation/download/#{@deviationid}`,
        da: @da,
        body: @deviation_download)
    end
    it 'requests the correct resource' do
      result = @da.download_deviation(@deviationid)
      assert_equal(result.class, DeviantArt::Deviation::Download)
      assert_respond_to(result, 'src')
      assert_respond_to(result, 'filesize')
      assert_respond_to(result, 'width')
      assert_respond_to(result, 'height')
    end
  end
end
