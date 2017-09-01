require 'deviantart/base'

module DeviantArt
  class User < Base
    ##
    # :method: userid
    # The user's ID as UUID, for example 80D3D72E-1B28-4F15-E529-A2EADB60B093.
    #
    # :method: username
    # The user's name, for example aycabta.
    #
    # :method: usericon
    # The user's icon URL.
    #
    # :method: type
    # It'll get "regular" or ...?
    #
    # :method: is_watching
    # Is authorized user watching the user?
    #
    # :method: details
    # Some values; age, joindate and sex.
    #
    # :method: geo
    # Some values; country, countryid and timezone.
    #
    # :method: profile
    # Some values; artist_level, artist_speciality, cover_photo, real_name, tagline, user_is_artist, profile_pic and website.
    #
    # :method: stats
    # Some values; friends and watchers.
    #
    attr_accessor :userid, :username, :usericon, :type, :is_watching, :details, :geo, :profile, :stats
    point_to_class [:profile, :profile_pic], DeviantArt::Deviation

    def to_s
      "#{self.class.name}: #{@username} #{@userid}"
    end
  end
end
