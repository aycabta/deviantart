require 'deviantart/base'

module DeviantArt
  class User::Whois < Base
    # :method: results
    #

    attr_accessor :results
    point_to_class [:results, :[]], DeviantArt::User
  end
end
