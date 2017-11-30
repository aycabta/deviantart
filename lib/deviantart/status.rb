require 'deviantart/base'

module DeviantArt
  class Status < Base
    # :method: statusid
    # An UUID for status

    # :method: body
    # Message body

    # :method: ts
    #

    # :method: url
    # An URL for status

    # :method: comments_count
    #

    # :method: is_share
    #

    # :method: is_deleted
    # Deleted flag

    # :method: author
    # An author name

    # :method: items
    #

    attr_accessor :statusid, :body, :ts, :url, :comments_count, :is_share, :is_deleted, :author, :items
    point_to_class [:author], DeviantArt::User
    point_to_class [:items, :[], :status], DeviantArt::Status
    point_to_class [:items, :[], :deviation], DeviantArt::Deviation

    def to_s
      "#{self.class.name}: #{@body} by #{@author.username} #{@statusid}"
    end
  end
end
