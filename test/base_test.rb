require 'helper'
require 'deviantart'
require 'deviantart/base'

describe DeviantArt::Base do
  describe 'DeviantArt::Base' do
    before do
      @base = DeviantArt::Base.new({})
    end
    it 'has inspect' do
      assert_equal('DeviantArt::Base', @base.inspect)
      assert_equal(@base.to_s, @base.inspect)
    end
  end
end
