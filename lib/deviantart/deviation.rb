require 'deviantart/base'

module DeviantArt
  class Deviation < Base
    attr_accessor :deviationid, :printid, :url, :title, :category, :category_path, :is_favourited, :is_deleted, :author, :stats
    attr_accessor :published_time, :allows_comments, :preview, :content, :thumbs, :videos, :flash, :daily_deviation
    attr_accessor :excerpt, :is_mature, :is_downloadable, :download_filesize, :challenge, :challenge_entry, :motion_book
    point_to_class [:author], DeviantArt::User
    point_to_class [:daily_deviation, :giver], DeviantArt::User
    point_to_class [:daily_deviation, :suggester], DeviantArt::User
  end
end
