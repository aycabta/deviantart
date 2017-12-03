require 'deviantart/base'

module DeviantArt
  class Error < Base
    # :method: error
    # Error type in JSON.
    # For example: invalid_request, unauthorized and server_error

    # :method: error_description
    #

    # :method: error_details
    #

    # :method: error_code
    #

    # :method: status_code
    # HTTP status code

    attr_accessor :error, :error_description, :error_details, :error_code, :status_code

    def initialize(json, status_code)
      super(json)
      @status_code = status_code
    end

    def to_s
      messages = []
      messages << self.class.name
      messages << "status_code: #{@status_code}"
      messages << "error_code: #{@error_code}" if @error_code
      messages << "error: #{@error}" if @error
      messages << "error_description: #{@error_description}" if @error_description
      messages << "error_details: #{@error_details}" if @error_details
      messages.join(', ')
    end
  end
end
