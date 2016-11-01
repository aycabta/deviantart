require 'deviantart/base'

module DeviantArt
  class User < Base
    attr_accessor :userid, :username, :usericon, :type, :is_watching, :details, :geo, :profile, :stats
    point_to_class [:profile, :profile_pic], DeviantArt::Deviation
  end
end
