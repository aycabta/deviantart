require 'helper'
require 'deviantart'
require 'deviantart/base'

describe DeviantArt::Base do
  describe '#inspect' do
    before do
      @base = DeviantArt::Base.new({})
    end
    it 'returns name' do
      assert_equal('DeviantArt::Base', @base.inspect)
      assert_equal(@base.to_s, @base.inspect)
    end
  end
end
