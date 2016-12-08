require 'helper'
require 'deviantart'

describe DeviantArt::Client do
  before(:all) do
    @da, @credentials = create_da
  end
  describe '#' do
    before do
      @refresh_authorization_code = fixture('refresh_authorization_code.json')
      stub_da_request(
        method: :post,
        url: "https://#{DeviantArt::Client.default_host}/oauth2/token",
        status_code: 200,
        body: @refresh_authorization_code)
    end
    it 'requests the correct resource' do
      @da.access_token = nil
      assert_nil(@da.access_token)
      @da.refresh_access_token
      assert(!@da.access_token.nil?)
    end
  end
end
