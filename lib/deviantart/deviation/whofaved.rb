require 'deviantart/base'

module DeviantArt
  class Deviation::WhoFaved < Base
    point_to_class [:results, :[], :user], DeviantArt::User
  end
end
