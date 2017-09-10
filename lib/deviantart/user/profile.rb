require 'deviantart/base'

module DeviantArt
  class User::Profile < Base
    # :method: user
    #

    # :method: is_watching
    #

    # :method: profile_url
    #

    # :method: user_is_artist
    #

    # :method: artist_level
    #

    # :method: artist_specialty
    #

    # :method: real_name
    #

    # :method: tagline
    #

    # :method: countryid
    #

    # :method: country
    #

    # :method: website
    #

    # :method: bio
    #

    # :method: cover_photo
    #

    # :method: profile_pic
    #

    # :method: last_status
    #

    # :method: stats
    #

    # :method: collections
    #

    # :method: galleries
    #

    attr_accessor :user, :is_watching, :profile_url, :user_is_artist, :artist_level, :artist_specialty, :real_name, :tagline
    attr_accessor :countryid, :country, :website, :bio, :cover_photo, :profile_pic, :last_status, :stats, :collections, :galleries
    point_to_class [:user], DeviantArt::User
    point_to_class [:profile_pic], DeviantArt::Deviation
    point_to_class [:last_status], DeviantArt::Status
  end
end
