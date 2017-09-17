require 'deviantart/base'

module DeviantArt
  class User::Statuses < Base
    # :method: has_more
    #

    # :method: next_offset
    #

    # :method: results
    #

    attr_accessor :has_more, :next_offset, :results
    point_to_class [:results, :[]], DeviantArt::Status
  end
end
