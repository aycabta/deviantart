require 'deviantart/base'

module DeviantArt
  class Gallery < Base
    attr_accessor :has_more, :next_offset, :name, :results
    point_to_class [:results, :[]], DeviantArt::Deviation
  end
end
