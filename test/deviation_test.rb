require 'helper'
require 'deviantart'

class DeviantArt::Client::Deviation::Test < Test::Unit::TestCase
  setup do
    @da, @credentials = create_da
  end
  sub_test_case '#get_deviation' do
    setup do
      @deviation = fixture('deviation.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/deviation/#{@deviation.json['deviationid']}",
        da: @da,
        body: @deviation)
    end
    test 'requests the correct resource' do
      resp = @da.get_deviation(@deviation.json['deviationid'])
      assert_instance_of(DeviantArt::Deviation, resp)
      assert_equal("DeviantArt::Deviation: #{@deviation.json['title']} by #{@deviation.json['author']['username']} #{@deviation.json['deviationid']}", resp.to_s)
      assert_instance_of(Array, resp.thumbs)
      assert_kind_of(Integer, resp.thumbs.first.width)
      assert_instance_of(DeviantArt::User, resp.author)
      resp.thumbs.first.height = 1234
      assert_equal(resp.thumbs.first.height, 1234)
      assert_equal(resp.deviationid, @deviation.json['deviationid'])
    end
  end
  sub_test_case '#get_deviation_content' do
    setup do
      @deviationid = fixture('deviation_content-input.json').json['deviationid']
      @deviation_content = fixture('deviation_content.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/deviation/content\?deviationid=.*`,
        da: @da,
        body: @deviation_content)
    end
    test 'requests the correct resource' do
      resp = @da.get_deviation_content(@deviationid)
      assert_instance_of(DeviantArt::Deviation::Content, resp)
      assert_instance_of(String, resp.html)
      assert_instance_of(String, resp.css)
      assert_instance_of(Array, resp.css_fonts)
    end
  end
  sub_test_case '#get_deviation_metadata' do
    setup do
      @deviation_metadata = fixture('deviation_metadata.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/deviation/metadata`,
        da: @da,
        body: @deviation_metadata)
    end
    test 'requests the correct resource' do
      resp = @da.get_deviation_metadata(@deviation_metadata.json['metadata'].first['deviationid'])
      assert_instance_of(DeviantArt::Deviation::Metadata, resp)
      assert_instance_of(Array, resp.metadata)
      assert_instance_of(DeviantArt::User, resp.metadata.first.author)
      assert_instance_of(String, resp.metadata.first.title)
    end
  end
  sub_test_case '#get_deviation_metadata with multi' do
    setup do
      @deviation_metadata_multi = fixture('deviation_metadata_multi.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/deviation/metadata`,
        da: @da,
        body: @deviation_metadata_multi)
    end
    test 'requests the correct resource' do
      resp = @da.get_deviation_metadata(@deviation_metadata_multi.json['metadata'].map{ |m| m['deviationid'] })
      assert_instance_of(DeviantArt::Deviation::Metadata, resp)
      assert_instance_of(Array, resp.metadata)
      assert_equal(@deviation_metadata_multi.json['metadata'].size, resp.metadata.size)
      assert_instance_of(DeviantArt::User, resp.metadata.first.author)
      assert_instance_of(String, resp.metadata.first.title)
    end
  end
  sub_test_case '#get_deviation_embeddedcontent' do
    setup do
      @deviationid = fixture('deviation_embeddedcontent-input.json').json['deviationid']
      @deviation_embeddedcontent = fixture('deviation_embeddedcontent.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/deviation/embeddedcontent\?deviationid=.*`,
        da: @da,
        body: @deviation_embeddedcontent)
    end
    test 'requests the correct resource' do
      resp = @da.get_deviation_embeddedcontent(@deviationid)
      assert_instance_of(DeviantArt::Deviation::EmbeddedContent, resp)
      assert_boolean(resp.has_more)
      assert_boolean(resp.has_less)
      assert_instance_of(Array, resp.results)
    end
  end
  sub_test_case '#get_deviation_whofaved' do
    setup do
      @deviationid = fixture('deviation_whofaved-input.json').json['deviationid']
      @deviation_whofaved = fixture('deviation_whofaved.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/deviation/whofaved\?deviationid=.*`,
        da: @da,
        body: @deviation_whofaved)
    end
    test 'requests the correct resource' do
      resp = @da.get_deviation_whofaved(@deviationid)
      assert_instance_of(DeviantArt::Deviation::WhoFaved, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(DeviantArt::User, resp.results.first.user)
    end
  end
  sub_test_case '#download_deviation' do
    setup do
      @deviationid = fixture('deviation_download-input.json').json['deviationid']
      @deviation_download = fixture('deviation_download.json')
      stub_da_request(
        method: :get,
        url: %r`^https://#{@da.host}/api/v1/oauth2/deviation/download/#{@deviationid}`,
        da: @da,
        body: @deviation_download)
    end
    test 'requests the correct resource' do
      resp = @da.download_deviation(@deviationid)
      assert_instance_of(DeviantArt::Deviation::Download, resp)
      assert_instance_of(String, resp.src)
      assert_kind_of(Integer, resp.filesize)
      assert_kind_of(Integer, resp.width)
      assert_kind_of(Integer, resp.height)
    end
  end
end
