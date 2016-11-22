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
    end
  end
end
