require 'deviantart/base'

module DeviantArt
  class Collections::Folders < Base
    attr_accessor :has_more, :next_offset, :results
    point_to_class [:results, :[], :deviations, :[]], DeviantArt::Deviation
  end
end
