require 'deviantart/base'

module DeviantArt
  class Deviation::EmbeddedContent < Base
    attr_accessor :has_more, :next_offset, :has_less, :prev_offset, :results
    point_to_class [:results, :[]], DeviantArt::Deviation
  end
end
