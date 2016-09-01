module DeviantArt
  module Deviation
    def get_deviation(deviationid)
      perform(:get, "/api/v1/oauth2/deviation/#{deviationid}")
    end

    def get_deviation_content(deviationid)
      perform(:get, "/api/v1/oauth2/deviation/content", { deviationid: deviationid })
    end
  end
end

