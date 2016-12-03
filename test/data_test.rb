require 'helper'
require 'deviantart'

describe DeviantArt::Client::Data do
  before(:all) do
    @da, @credentials = create_da
  end
  describe '#get_countries' do
    before do
      @countries = fixture('data_countries.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/data/countries",
        da: @da,
        body: @countries)
    end
    it 'requests the correct resource' do
      resp = @da.get_countries
      assert_instance_of(DeviantArt::Data::Countries, resp)
      assert_instance_of(Array, resp.results)
      assert_instance_of(String, resp.results.first.name)
    end
  end
  describe '#get_privacy' do
    before do
      @privacy = fixture('data_privacy.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/data/privacy",
        da: @da,
        body: @privacy)
    end
    it 'requests the correct resource' do
      resp = @da.get_privacy
      assert_instance_of(DeviantArt::Data::Privacy, resp)
      assert_instance_of(String, resp.text)
    end
  end
  describe '#get_submission' do
    before do
      @submission = fixture('data_submission.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/data/submission",
        da: @da,
        body: @submission)
    end
    it 'requests the correct resource' do
      resp = @da.get_submission
      assert_instance_of(DeviantArt::Data::Submission, resp)
      assert_instance_of(String, resp.text)
    end
  end
  describe '#get_tos' do
    before do
      @tos = fixture('data_tos.json')
      stub_da_request(
        method: :get,
        url: "https://#{@da.host}/api/v1/oauth2/data/tos",
        da: @da,
        body: @tos)
    end
    it 'requests the correct resource' do
      resp = @da.get_tos
      assert_instance_of(DeviantArt::Data::TOS, resp)
      assert_instance_of(String, resp.text)
    end
  end
end
