require 'deviantart/deviation'
require 'deviantart/deviation/content'
require 'deviantart/deviation/whofaved'
require 'deviantart/deviation/download'

module DeviantArt
  class Client
    module Deviation
      # Fetch a deviation details
      def get_deviation(deviationid)
        DeviantArt::Deviation.new(perform(:get, "/api/v1/oauth2/deviation/#{deviationid}"))
      end

      # Fetch full data that is not included in the main devaition details
      def get_deviation_content(deviationid)
        DeviantArt::Deviation::Content.new(perform(:get, '/api/v1/oauth2/deviation/content', { deviationid: deviationid }))
      end

      # Fetch a list of users who faved the deviation
      def get_deviation_whofaved(deviationid, offset: 0, limit: 10)
        params = {}
        params['deviationid'] = deviationid
        params['offset'] = offset if offset != 0
        params['limit'] = limit if limit != 10
        DeviantArt::Deviation::WhoFaved.new(perform(:get, '/api/v1/oauth2/deviation/whofaved', params))
      end

      # Get the original file download (if allowed)
      def download_deviation(deviationid)
        DeviantArt::Deviation::Download.new(perform(:get, "/api/v1/oauth2/deviation/download/#{deviationid}"))
      end

      # TODO: embeddedcontent, metadata
    end
  end
end
