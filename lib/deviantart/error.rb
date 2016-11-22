require 'deviantart/base'

module DeviantArt
  class Error < Base
    attr_accessor :error, :error_description, :error_details, :error_code, :status_code

    def initialize(json, status_code)
      super(json)
      @status_code = status_code
    end
  end
end
