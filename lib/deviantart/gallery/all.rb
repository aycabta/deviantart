require 'deviantart/base'

module DeviantArt
  class Gallery::All < Base
    # :method: has_more
    # Boolean field, indicating whether or not there is more data available.

    # :method: next_offset
    # To fetch the next page of data, send the value of this field as an
    # offset or cursor to the endpoint.

    # :method: results
    # Friends list as DeviantArt::Deviation.

    attr_accessor :has_more, :next_offset, :results
    point_to_class [:results, :[]], DeviantArt::Deviation
  end
end
