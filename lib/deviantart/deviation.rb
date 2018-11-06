require 'deviantart/base'

module DeviantArt
  ##
  # Deviation class for API response
  class Deviation < Base
    # :method: deviationid
    # An UUID for deviation

    # :method: printid
    #

    # :method: url
    # The URL for deviation

    # :method: title
    # The title of deviation

    # :method: category
    # Category as String like "Fantasy"

    # :method: category_path
    # Category path as String like "digitalart/paintings/fantasy"

    # :method: is_favourited
    # Is this favorited by you?

    # :method: is_deleted
    # The flag for what the deviation is deleted

    # :method: author
    # The author of this deviation as DeviantArt::User

    # :method: stats
    # This has numbers of comments and favorites

    # :method: published_time
    # Published time as Unix time

    # :method: allows_comments
    # Boolean

    # :method: preview
    # This has +src+ as image URL, height and width as pixel size and transparency as boolean

    # :method: content
    # This has +src+ as image URL, height and width as pixel size, transparency as boolean and filesize as byte

    # :method: thumbs
    # Thumbnail list with +src+ as URL, height, width and transparency

    # :method: videos
    #

    # :method: flash
    #

    # :method: daily_deviation
    #

    # :method: excerpt
    #

    # :method: is_mature
    # Is this mature content?

    # :method: is_downloadable
    # Is this danloadable?

    # :method: download_filesize
    # The filesize of the image that is from ["content"]["src"]

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
