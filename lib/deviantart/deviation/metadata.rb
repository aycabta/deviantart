require 'deviantart/base'

module DeviantArt
  class Deviation::Metadata < Base
    attr_accessor :metadata
    point_to_class [:metadata, :[], :author], DeviantArt::User
  end
end
