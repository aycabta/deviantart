require 'helper'
require 'deviantart'

describe DeviantArt::Error do
  before(:all) do
    @da = DeviantArt.new
  end
  describe '#get_deviation' do
    before do
      @error = fixture('error_404.json')
      @dummyid = 'dummy-id'
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/deviation/#{@dummyid}",
        body: @error, status_code: 404)
    end
    it 'requests the correct resource' do
      result = @da.get_deviation(@dummyid)
      assert_instance_of(DeviantArt::Error, result)
      assert_equal(404, result.status_code)
      assert_equal("error", result.status)
      assert_equal("invalid_request", result.error)
      assert_equal("Api endpoint not found.", result.error_description)
    end
  end
  describe '#get_deviation' do
    before do
      @error = fixture('error_access_token.json')
      @deviation = fixture('deviation.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/deviation/#{@deviation.json['deviationid']}",
        body: @error, status_code: 401)
    end
    it 'requests the correct resource' do
      result = @da.get_deviation(@deviation.json['deviationid'])
      assert_instance_of(DeviantArt::Error, result)
      assert_equal(401, result.status_code)
      assert_equal("error", result.status)
      assert_equal("invalid_request", result.error)
      assert_equal("Must provide an access_token to access this resource.", result.error_description)
    end
  end
end
