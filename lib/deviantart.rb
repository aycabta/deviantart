require "deviantart/version"
require "deviantart/client"

module DeviantArt
  def self.new(*args, &block)
    DeviantArt::Client.new(*args, &block)
  end
end
