require 'deviantart/deviation'
require 'net/http'
require 'uri'
require 'json'

class Net::HTTPResponse
  attr_accessor :json
end

module DeviantArt
  class Client
    include DeviantArt::Deviation
    attr_accessor :access_token, :client_id, :client_secret, :code, :redirect_uri, :grant_type, :access_token_auto_refresh
    attr_writer :user_agent
    @@host = 'www.deviantart.com'

    def initialize
      yield(self) if block_given?
      @http = Net::HTTP.new(@@host, 443)
      @http.use_ssl = true
    end

    def user_agent
      @user_agent ||= "DeviantArtRubyGem/#{DeviantArt::Version}"
    end

    def request(method, path, params = {})
      uri = URI.parse("https://#{@@host}#{path}")
      case method
      when :get
        uri.query = URI.encode_www_form(params)
        request = Net::HTTP::Get.new(uri)
      when :post
        request = Net::HTTP::Post.new(uri.path)
        request.set_form_data(params)
      end
      request['User-Agent'] = user_agent
      if not @access_token.nil?
        request["Authorization"] = "Bearer #{@access_token}"
      end
      response = @http.request(request)
      response.json = JSON.parse(response.body)
      response
    end

    def refresh_client_credentials
      response = request(
        :post, '/oauth2/token',
        { grant_type: 'client_credentials', client_id: @client_id, client_secret: @client_secret }
      )
      if response.code == '200'
        @access_token = response.json['access_token']
      else
        @access_token = nil
      end
    end

    def refresh_authorization_code
      response = request(
        :post, '/oauth2/token',
        { grant_type: 'authorization_code', redirect_uri: @redirect_uri, client_id: @client_id, client_secret: @client_secret }
      )
      if response.code == '200'
        @access_token = response.json['access_token']
      else
        @access_token = nil
      end
    end

    def refresh_access_token
      case @grant_type.to_sym
      when :authorization_code
        refresh_authorization_code
      when :client_credentials
        refresh_client_credentials
      end
    end

    def perform(method, path, params = {})
      if @access_token.nil? && @access_token_auto_refresh
        refresh_access_token
      end
      response = request(method, path, params)
      if response.code == '401' && @access_token_auto_refresh
        refresh_access_token
        response = request(method, path, params)
      end
      response.json
    end
  end
end

