require 'deviantart/deviation'
require 'deviantart/deviation/content'
require 'deviantart/deviation/whofaved'
require 'deviantart/deviation/download'
require 'deviantart/deviation/embeddedcontent'
require 'deviantart/deviation/metadata'

module DeviantArt
  class Client
    module Deviation
      # Fetch a deviation details
      def get_deviation(deviationid)
        perform(DeviantArt::Deviation, :get, "/api/v1/oauth2/deviation/#{deviationid}")
      end

      # Fetch full data that is not included in the main devaition details
      def get_deviation_content(deviationid)
        perform(DeviantArt::Deviation::Content, :get, '/api/v1/oauth2/deviation/content', { deviationid: deviationid })
      end

      # Fetch content embedded in a deviation.
      # Journal and literature deviations support embedding of deviations inside them.
      def get_deviation_embeddedcontent(deviationid, offset_deviationid: nil, offset: 0, limit: 10)
        params = { deviationid: deviationid }
        params['offset_deviationid'] = offset_deviationid if offset_deviationid
        params['offset'] = offset if offset != 0
        params['limit'] = limit if limit != 10
        perform(DeviantArt::Deviation::EmbeddedContent, :get, '/api/v1/oauth2/deviation/embeddedcontent', params)
      end

      # Fetch deviation metadata for a set of deviations.
      # This endpoint is limited to 50 deviations per query when fetching the base data and 10 when fetching extended data.
      def get_deviation_metadata(deviationids, ext_submission: false, ext_camera: false, ext_stats: false, ext_collection: false)
        params = { deviationids: deviationids.is_a?(Enumerable) ? deviationids : [deviationids] }
        params['ext_submission'] = ext_submission
        params['ext_camera'] = ext_camera
        params['ext_stats'] = ext_stats
        params['ext_collection'] = ext_collection
        perform(DeviantArt::Deviation::Metadata, :get, '/api/v1/oauth2/deviation/metadata', params)
      end

      # Fetch a list of users who faved the deviation
      def get_deviation_whofaved(deviationid, offset: 0, limit: 10)
        params = {}
        params['deviationid'] = deviationid
        params['offset'] = offset if offset != 0
        params['limit'] = limit if limit != 10
        perform(DeviantArt::Deviation::WhoFaved, :get, '/api/v1/oauth2/deviation/whofaved', params)
      end

      # Get the original file download (if allowed)
      def download_deviation(deviationid)
        perform(DeviantArt::Deviation::Download, :get, "/api/v1/oauth2/deviation/download/#{deviationid}")
      end

      # TODO: metadata
    end
  end
end
