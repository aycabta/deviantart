require 'deviantart/base'

module DeviantArt
  class Deviation::Content < Base
    attr_accessor :html, :css, :css_fonts
  end
end
