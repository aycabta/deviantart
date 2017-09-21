require 'deviantart/base'

module DeviantArt
  class Gallery::All < Base
    # :method: has_more
    #

    # :method: next_offset
    #

    # :method: results
    #

    attr_accessor :has_more, :next_offset, :results
    point_to_class [:results, :[]], DeviantArt::Deviation
  end
end
