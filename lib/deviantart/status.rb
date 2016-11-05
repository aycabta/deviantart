require 'deviantart/base'

module DeviantArt
  class Status < Base
    attr_accessor :statusid, :body, :ts, :url, :comments_count, :is_share, :is_deleted, :author, :items
    point_to_class [:author], DeviantArt::User
    point_to_class [:items, :[], :status], DeviantArt::Status
    point_to_class [:items, :[], :deviation], DeviantArt::Deviation
  end
end
