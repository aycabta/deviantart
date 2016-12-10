require 'deviantart/base'

module DeviantArt
  class ClientCredentials::AccessToken < Base
    attr_accessor :expires_in, :status, :access_token, :token_type
  end
end

