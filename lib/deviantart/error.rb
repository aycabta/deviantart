require 'deviantart/base'

module DeviantArt
  class Error < Base
    # :method: error
    # Error type in JSON.
    # For example: +invalid_request+, +unauthorized+ and +server_error+

    # :method: error_description
    # The error message. You should NOT parse this as it may change, use error
    # or +error_code+ for conditional logic within your app.

    # :method: error_details
    # Optional.
    # For validation errors, this will be a key/value map containing error
    # information for each field.

    # :method: error_code
    # Optional.
    # Some endpoints may provide additional error codes so your application
    # can provide fine grained handling of the error states. Each endpoint
    # will define any additional codes in its documentation, all codes start
    # from zero and are specific to that particular endpoint.

    # :method: status_code
    # This is the HTTP status code of response.

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
