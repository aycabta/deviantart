require 'deviantart/base'

module DeviantArt
  class User < Base
    point_to_class [:profile, :profile_pic], DeviantArt::Deviation
  end
end
