module OMDB
  class Client

    include HTTParty
    base_uri 'http://omdbapi.com'

    def title(title)
      response = self.class.get '/', query: { t: title }
      response.parsed_response
    end

    def search(query)
      response = self.class.get '/', query: { s: query }
      response.parsed_response
    end

  end
end