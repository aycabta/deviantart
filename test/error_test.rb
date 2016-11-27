require 'helper'
require 'deviantart'

describe DeviantArt::Error do
  describe '#get_deviation 404' do
    before do
      @da = DeviantArt.new
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
  describe '#get_deviation 401' do
    before do
      @da = DeviantArt.new
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
  describe '#get_deviation version error' do
    before do
      @da, @credentials = create_da
      @error = fixture('error_version_error.json')
      @deviation = fixture('deviation.json')
      @minor_version = 'test'
      dummy_version = { 'dA-minor-version' => @minor_version }
      @da.headers = @da.headers.merge(dummy_version)
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/deviation/#{@deviation.json['deviationid']}",
        da: @da,
        body: @error, status_code: 404, headers: dummy_version)
    end
    it 'requests the correct resource' do
      result = @da.get_deviation(@deviation.json['deviationid'])
      assert_instance_of(DeviantArt::Error, result)
      assert_equal(404, result.status_code)
      assert_equal("error", result.status)
      assert_equal("version_error", result.error)
      assert_equal("Api Version 1.#{@minor_version} not supported", result.error_description)
    end
  end
  describe '#get_deviation 401 invalid token' do
    before do
      client_id = 9999
      client_secret = 'GreatPerfect'
      @da = DeviantArt.new do |config|
        config.client_id = client_id
        config.client_secret = client_secret
        config.grant_type = :client_credentials
        config.access_token_auto_refresh = true
      end
      @error = fixture('error_401_invalid_token.json')
      @deviation = fixture('deviation.json')
      @minor_version = 'test'
      dummy_token = { 'Authorization' => "Bearer dummybearer" }
      @da.headers = @da.headers.merge(dummy_token)
      stub_request(:post, "https://#{DeviantArt::Client.default_host}/oauth2/token")
        .to_return(status: 401, body: @error)
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/deviation/#{@deviation.json['deviationid']}",
        da: @da,
        body: @error, status_code: 404, headers: dummy_token)
    end
    it 'requests the correct resource' do
      result = @da.get_deviation(@deviation.json['deviationid'])
      assert_instance_of(DeviantArt::Error, result)
      assert_equal("error", result.status)
      assert_equal("invalid_token", result.error)
      assert_equal("Invalid token.", result.error_description)
    end
  end
end
