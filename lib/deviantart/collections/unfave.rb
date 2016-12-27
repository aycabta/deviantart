require 'deviantart/base'

module DeviantArt
  class Collections::Unfave < Base
    attr_accessor :success, :favourites
  end
end
