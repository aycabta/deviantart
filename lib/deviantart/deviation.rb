require 'deviantart/base'

module DeviantArt
  class Deviation < Base
    point_to_class [:author], DeviantArt::User
    point_to_class [:daily_deviation, :giver], DeviantArt::User
    point_to_class [:daily_deviation, :suggester], DeviantArt::User
  end
end
