require 'deviantart/base'

module DeviantArt
  class User::Friends::Search < Base
    attr_accessor :results
    point_to_class [:results, :[]], DeviantArt::User
  end
end
