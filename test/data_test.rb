require 'helper'
require 'deviantart'

class DeviantArt::Client::Data::Test < Test::Unit::TestCase
  setup do
    @da, @credentials = create_da
  end
  sub_test_case '#get_countries' do
    setup do
      @countries = fixture('data_countries.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/data/countries",
        da: @da,
        body: @countries)
    end
    test 'requests the correct resource' do
      resp = @da.get_countries
      assert_instance_of(DeviantArt::Data::Countries, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(String, resp.results.first.name)
    end
  end
  sub_test_case '#get_privacy' do
    setup do
      @privacy = fixture('data_privacy.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/data/privacy",
        da: @da,
        body: @privacy)
    end
    test 'requests the correct resource' do
      resp = @da.get_privacy
      assert_instance_of(DeviantArt::Data::Privacy, resp)
      assert_instance_of(String, resp.text)
    end
  end
  sub_test_case '#get_submission' do
    setup do
      @submission = fixture('data_submission.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/data/submission",
        da: @da,
        body: @submission)
    end
    test 'requests the correct resource' do
      resp = @da.get_submission
      assert_instance_of(DeviantArt::Data::Submission, resp)
      assert_instance_of(String, resp.text)
    end
  end
  sub_test_case '#get_tos' do
    setup do
      @tos = fixture('data_tos.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/data/tos",
        da: @da,
        body: @tos)
    end
    test 'requests the correct resource' do
      resp = @da.get_tos
      assert_instance_of(DeviantArt::Data::TOS, resp)
      assert_instance_of(String, resp.text)
    end
  end
end
