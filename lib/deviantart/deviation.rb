module DeviantArt
  module Deviation
    def get_deviation(deviationid)
      perform(:get, "/api/v1/oauth2/deviation/#{deviationid}")
    end

    def get_deviation_content(deviationid)
      perform(:get, "/api/v1/oauth2/deviation/content", { deviationid: deviationid })
    end

    def get_deviation_whofaved(deviationid, offset: 0, limit: 10)
      params = {}
      params['deviationid'] = deviationid
      params['offset'] = offset if offset != 0
      params['limit'] = limit if limit != 10
      perform(:get, "/api/v1/oauth2/deviation/whofaved", params)
    end

    def download_deviation(deviationid)
      perform(:get, "/api/v1/oauth2/deviation/download/#{deviationid}")
    end
  end
end

