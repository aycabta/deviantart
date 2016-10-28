require 'deviantart/client/deviation'
require 'deviantart/client/gallery'
require 'deviantart/client/collections'
require 'deviantart/client/user'
require 'deviantart/client/data'
require 'deviantart/client/feed'
# TODO: comments, cured, messages, notes, stash, util
require 'net/http'
require 'uri'
require 'json'

class Net::HTTPResponse
  attr_accessor :json
end

module DeviantArt
  class Client
    include DeviantArt::Client::Deviation
    include DeviantArt::Client::Gallery
    include DeviantArt::Client::Collections
    include DeviantArt::Client::User
    include DeviantArt::Client::Data
    include DeviantArt::Client::Feed
    attr_accessor :access_token, :client_id, :client_secret, :code, :redirect_uri, :grant_type, :access_token_auto_refresh, :refresh_token, :host
    attr_writer :user_agent
    @@default_host = 'www.deviantart.com'

    # Create client object.
    #
    # [#host] Host name to access API.
    # [#access_token_auto_refresh] Bool for auto refresh access token.
    # [#grant_type]
    #   Use for refresh token.
    #   - +:authorization_code+
    #   - +:client_credentials+
    # [#access_token] This is valid access token for now.
    #
    # For refresh token with +:authorization_code+
    #
    # [#client_id] App's +client_id+.
    # [#client_secret] App's +client_secret+.
    # [#redirect_uri] URL what is exactly match the value in authorization step.
    # [#code] Authorization step returns this.
    # [#refresh_token] Refresh token for +:authorization_code+.
    #
    # For refresh token with +:client_credentials+
    #
    # [#client_id] App's +client_id+.
    # [#client_secret] App's +client_secret+.
    def initialize(options = {})
      @access_token = nil
      @host = @@default_host
      @on_refresh_access_token = nil
      @on_refresh_authorization_code = nil
      options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
      yield(self) if block_given?
      @http = Net::HTTP.new(@host, 443)
      @http.use_ssl = true
    end

    # Default host name, it's 'www.deviantart.com'
    def self.default_host
      @@default_host
    end

    # User agent name
    def user_agent
      @user_agent ||= "DeviantArtRubyGem/#{DeviantArt::VERSION}/#{RUBY_DESCRIPTION}"
    end

    # Auto refresh access token flag
    def access_token_auto_refresh?
      @access_token_auto_refresh
    end

    # Access API with params by method
    def perform(method, path, params = {})
      if @access_token.nil? && access_token_auto_refresh?
        refresh_access_token
      end
      response = request(method, path, params)
      if response.code == '401' && access_token_auto_refresh?
        refresh_access_token
        response = request(method, path, params)
      end
      response.json
    end

    # Call given block when authorization code is refreshed
    def on_refresh_authorization_code(&block)
      @on_refresh_authorization_code = block
    end

    # Call given block when access token is refreshed
    def on_refresh_access_token(&block)
      @on_refresh_access_token = block
    end

  private

    def request(method, path, params = {})
      uri = URI.parse("https://#{@host}#{path}")
      case method
      when :get
        uri.query = URI.encode_www_form(params)
        request = Net::HTTP::Get.new(uri)
      when :post
        request = Net::HTTP::Post.new(uri.path)
        if params.any?{ |key, value| value.is_a?(Enumerable) }
          converted_params = []
          params.each do |key, value|
            if value.is_a?(Enumerable)
              value.each_index do |i|
                converted_params << ["#{key}[#{i}]", value[i]]
              end
            else
              converted_params << [key, value]
            end
          end
          request.body = URI.encode_www_form(converted_params)
        else
          request.set_form_data(params)
        end
      end
      request['Content-Type'] = 'application/x-www-form-urlencoded'
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
        @on_refresh_access_token.call(@access_token) if @on_refresh_access_token
      else
        @access_token = nil
      end
    end

    def refresh_authorization_code
      response = request(
        :post, '/oauth2/token',
        { grant_type: 'refresh_token', client_id: @client_id, client_secret: @client_secret, refresh_token: @refresh_token }
      )
      if response.code == '200'
        @access_token = response.json['access_token']
        @on_refresh_access_token.call(@access_token) if @on_refresh_access_token
        @on_refresh_authorization_code.call(@access_token, response.json['refresh_token']) if @on_refresh_authorization_code
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
  end
end
