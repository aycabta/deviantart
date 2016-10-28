require 'deviantart/base'

module DeviantArt
  class Status < Base
    point_to_class [:author], DeviantArt::User
    point_to_class [:items, :[], :status], DeviantArt::Status
    point_to_class [:items, :[], :deviation], DeviantArt::Deviation
  end
end
