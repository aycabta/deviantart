module DeviantArt
  module Deviation
    def get_deviation(deviationid)
      perform(:get, "/api/v1/oauth2/deviation/#{deviationid}")
    end
  end
end

