require 'deviantart/base'

module DeviantArt
  class Feed::Profile < Base
    attr_accessor :cursor, :has_more, :items
    point_to_class [:items, :[], :by_user], DeviantArt::User
    point_to_class [:items, :[], :status], DeviantArt::Status
    point_to_class [:items, :[], :deviations, :[]], DeviantArt::Deviation
    #point_to_class [:items, :[], :comment], DeviantArt::Comment
    #point_to_class [:items, :[], :comment_parent], DeviantArt::Comment
    point_to_class [:items, :[], :comment_deviation], DeviantArt::Deviation
    point_to_class [:items, :[], :comment_profile], DeviantArt::User
  end
end
