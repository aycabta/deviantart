require 'deviantart/base'

module DeviantArt
  class User::Statuses < Base
    attr_accessor :has_more, :next_offset, :results
    point_to_class [:results, :[]], DeviantArt::User
  end
end
