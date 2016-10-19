require 'helper'
require 'deviantart'

describe DeviantArt::Data do
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
      result = @da.get_countries
      assert_equal(result.class, Hash)
      assert_includes(result, 'results')
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
      result = @da.get_privacy
      assert_equal(result.class, Hash)
      assert_includes(result, 'text')
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
      result = @da.get_submission
      assert_equal(result.class, Hash)
      assert_includes(result, 'text')
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
      result = @da.get_tos
      assert_equal(result.class, Hash)
      assert_includes(result, 'text')
    end
  end
end
