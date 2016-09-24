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
        url: "https://#{DeviantArt::Client.host}/api/v1/oauth2/data/countries",
        da: @da,
        body: @countries)
    end
    it 'requests the correct resource' do
      result = @da.get_countries
      assert_equal(result.class, Hash)
      assert_includes(result, 'results')
    end
  end
end
