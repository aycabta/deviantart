module DeviantArt
  module Data
    # Get a list of countries
    def get_countries
      perform(:get, '/api/v1/oauth2/data/countries')
    end

    # Returns the DeviantArt Privacy Policy
    def get_privacy
      perform(:get, '/api/v1/oauth2/data/privacy')
    end

    # Returns the DeviantArt Submission Policy
    def get_submission
      perform(:get, '/api/v1/oauth2/data/submission')
    end
  end
end

