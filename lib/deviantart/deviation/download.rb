require 'deviantart/base'

module DeviantArt
  class Deviation::Download < Base
    attr_accessor :src, :width, :height, :filesize
  end
end
