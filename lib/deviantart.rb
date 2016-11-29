require 'deviantart/version'
require 'deviantart/client'
require 'deviantart/base'
require 'deviantart/deviation'
require 'deviantart/user'
require 'deviantart/status'

module DeviantArt
  # Bypass args and block to DeviantArt::Client
  # ...for backward compatibility
  def self.new(*args, &block)
    DeviantArt::Client.new(*args, &block)
  end
end
