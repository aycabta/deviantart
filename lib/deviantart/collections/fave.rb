require 'deviantart/base'

module DeviantArt
  class Collections::Fave < Base
    attr_accessor :success, :favourites
  end
end
