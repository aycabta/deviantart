require 'deviantart/base'

module DeviantArt
  class Deviation::WhoFaved < Base
    attr_accessor :has_more, :next_offset, :results
    point_to_class [:results, :[], :user], DeviantArt::User
  end
end
