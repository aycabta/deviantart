require 'deviantart/base'

module DeviantArt
  class User < Base
    attr_accessor :userid, :username, :usericon, :type, :is_watching, :details, :geo, :profile, :stats
    point_to_class [:profile, :profile_pic], DeviantArt::Deviation

    def inspect
      "#{self.class.name}: #{@username} #{@userid}"
    end

    def to_s
      inspect
    end
  end
end
