require 'deviantart/base'

module DeviantArt
  class AuthorizationCode::AccessToken < Base
    attr_accessor :expires_in, :status, :access_token, :token_type, :refresh_token, :scope
  end
end
