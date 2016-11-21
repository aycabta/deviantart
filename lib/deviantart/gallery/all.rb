require 'deviantart/base'

module DeviantArt
  class Gallery::All < Base
    attr_accessor :has_more, :next_offset, :results
    point_to_class [:results, :[]], DeviantArt::Deviation
  end
end
