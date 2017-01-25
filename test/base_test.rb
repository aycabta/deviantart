require 'helper'
require 'deviantart'
require 'deviantart/base'
require 'deviantart/deviation'

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
  describe '.point_to_class' do
    before do
      klass = Class.new(DeviantArt::Base)
      klass.__send__(:attr_accessor, :has_more, :next_offset, :name, :results)
      klass.point_to_class [:results, :[]], DeviantArt::Deviation
      @instance = klass.new({
        has_more: false,
        next_offset: nil,
        name: 'test',
        results: [
          { title: 'aaa' },
          { title: 'bbb' }
        ]
      })
    end
    it 'builds attributes' do
      assert_kind_of(DeviantArt::Base, @instance)
      assert_instance_of(Array, @instance.results)
      assert_instance_of(DeviantArt::Deviation, @instance.results.first)
    end
  end
end
