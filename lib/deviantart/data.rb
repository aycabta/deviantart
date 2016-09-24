module DeviantArt
  module Data
    def get_countries
      perform(:get, '/api/v1/oauth2/data/countries')
    end
  end
end

