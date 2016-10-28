require 'deviantart/base'

module DeviantArt
  class User::Profile < Base
    point_to_class [:user], DeviantArt::User
    point_to_class [:profile_pic], DeviantArt::Deviation
    point_to_class [:last_status], DeviantArt::Status
  end
end
