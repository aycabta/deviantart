require 'deviantart/base'

module DeviantArt
  class User::Whois < Base
    attr_accessor :results
    point_to_class [:results, :[]], DeviantArt::User
  end
end
