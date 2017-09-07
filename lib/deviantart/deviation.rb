require 'deviantart/base'

module DeviantArt
  class Deviation < Base
    # :method: deviationid
    #

    # :method: printid
    #

    # :method: url
    #

    # :method: title
    #

    # :method: category
    #

    # :method: category_path
    #

    # :method: is_favourited
    #

    # :method: is_deleted
    #

    # :method: author
    #

    # :method: stats
    #

    # :method: published_time
    #

    # :method: allows_comments
    #

    # :method: preview
    #

    # :method: content
    #

    # :method: thumbs
    #

    # :method: videos
    #

    # :method: flash
    #

    # :method: daily_deviation
    #

    # :method: excerpt
    #

    # :method: is_mature
    #

    # :method: is_downloadable
    #

    # :method: download_filesize
    #

    # :method: challenge
    #

    # :method: challenge_entry
    #

    # :method: motion_book
    #

    attr_accessor :deviationid, :printid, :url, :title, :category, :category_path, :is_favourited, :is_deleted, :author, :stats
    attr_accessor :published_time, :allows_comments, :preview, :content, :thumbs, :videos, :flash, :daily_deviation
    attr_accessor :excerpt, :is_mature, :is_downloadable, :download_filesize, :challenge, :challenge_entry, :motion_book
    point_to_class [:author], DeviantArt::User
    point_to_class [:daily_deviation, :giver], DeviantArt::User
    point_to_class [:daily_deviation, :suggester], DeviantArt::User

    def to_s
      "#{self.class.name}: #{@title} by #{@author.username} #{@deviationid}"
    end
  end
end
