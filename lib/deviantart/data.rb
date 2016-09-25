module DeviantArt
  module Data
    def get_countries
      perform(:get, '/api/v1/oauth2/data/countries')
    end
    def get_privacy
      perform(:get, '/api/v1/oauth2/data/privacy')
    end
  end
end

