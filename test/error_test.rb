require 'helper'
require 'deviantart'

class DeviantArt::Error::Test < Test::Unit::TestCase
  sub_test_case '#get_deviation 404 API endpoint not found' do
    setup do
      @da = DeviantArt::Client.new
      @error = fixture('error_404_api_endpoint_not_found.json')
      @dummyid = 'dummy-id'
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/deviation/#{@dummyid}",
        body: @error, status_code: 404)
    end
    test 'requests the correct resource' do
      resp = @da.get_deviation(@dummyid)
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(404, resp.status_code)
      assert_equal('error', resp.status)
      assert_equal('invalid_request', resp.error)
      assert_equal('Api endpoint not found.', resp.error_description)
    end
  end
  sub_test_case '#get_deviation 401 invalid request with no access token' do
    setup do
      @da = DeviantArt::Client.new
      @error = fixture('error_401_invalid_request_with_no_access_token.json')
      @deviation = fixture('deviation.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/deviation/#{@deviation.json['deviationid']}",
        body: @error, status_code: 401)
    end
    test 'requests the correct resource' do
      resp = @da.get_deviation(@deviation.json['deviationid'])
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(401, resp.status_code)
      assert_equal('error', resp.status)
      assert_equal('invalid_request', resp.error)
      assert_equal('Must provide an access_token to access this resource.', resp.error_description)
    end
  end
  sub_test_case '#get_deviation 404 version error' do
    setup do
      @da, @credentials = create_da
      @error = fixture('error_404_version_error.json')
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
    test 'requests the correct resource' do
      resp = @da.get_deviation(@deviation.json['deviationid'])
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal(404, resp.status_code)
      assert_equal('error', resp.status)
      assert_equal('version_error', resp.error)
      assert_equal("Api Version 1.#{@minor_version} not supported", resp.error_description)
    end
  end
  sub_test_case '#get_deviation 401 invalid token' do
    setup do
      @da = DeviantArt::Client.new do |config|
        config.client_id = 9999
        config.client_secret = 'GreatPerfect'
        config.grant_type = :client_credentials
        config.access_token_auto_refresh = true
      end
      @error = fixture('error_401_invalid_token.json')
      @deviation = fixture('deviation.json')
      @minor_version = 'test'
      dummy_token = { 'Authorization' => "Bearer dummybearer" }
      @da.headers = @da.headers.merge(dummy_token)
      stub_da_request(
        method: :post,
        url: "https://#{DeviantArt::Client.default_host}/oauth2/token",
        status_code: 401,
        body: @error)
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/deviation/#{@deviation.json['deviationid']}",
        da: @da,
        body: @error, status_code: 404, headers: dummy_token)
    end
    test 'requests the correct resource' do
      resp = @da.get_deviation(@deviation.json['deviationid'])
      assert_instance_of(DeviantArt::Error, resp)
      assert_equal('error', resp.status)
      assert_equal('invalid_token', resp.error)
      assert_equal('Invalid token.', resp.error_description)
    end
  end
end
