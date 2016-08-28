module DeviantArt
  module Deviation
    def get_deviation(id)
      perform(:get, "/api/v1/oauth2/deviation/#{id}")
    end
  end
end

