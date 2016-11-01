require 'deviantart/base'

module DeviantArt
  class User::Profile < Base
    attr_accessor :user, :is_watching, :profile_url, :user_is_artist, :artist_level, :artist_specialty, :real_name, :tagline
    attr_accessor :countryid, :country, :website, :bio, :cover_photo, :profile_pic, :last_status, :stats, :collections, :galleries
    point_to_class [:user], DeviantArt::User
    point_to_class [:profile_pic], DeviantArt::Deviation
    point_to_class [:last_status], DeviantArt::Status
  end
end
