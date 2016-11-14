require 'deviantart/data'
require 'deviantart/data/countries'
require 'deviantart/data/privacy'
require 'deviantart/data/submission'
require 'deviantart/data/tos'

module DeviantArt
  class Client
    module Data
      # Get a list of countries
      def get_countries
        DeviantArt::Data::Countries.new(perform(:get, '/api/v1/oauth2/data/countries'))
      end

      # Returns the DeviantArt Privacy Policy
      def get_privacy
        DeviantArt::Data::Privacy.new(perform(:get, '/api/v1/oauth2/data/privacy'))
      end

      # Returns the DeviantArt Submission Policy
      def get_submission
        DeviantArt::Data::Submission.new(perform(:get, '/api/v1/oauth2/data/submission'))
      end

      # Returns the DeviantArt Terms of Service
      def get_tos
        DeviantArt::Data::TOS.new(perform(:get, '/api/v1/oauth2/data/tos'))
      end
    end
  end
end
