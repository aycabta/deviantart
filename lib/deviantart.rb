require 'deviantart/version'
require 'deviantart/client'

module DeviantArt
  # Bypass args and block to DeviantArt::Client
  def self.new(*args, &block)
    DeviantArt::Client.new(*args, &block)
  end
end
