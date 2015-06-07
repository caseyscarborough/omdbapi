module OMDB

  # Client for handling requests to the omdbapi.com API.
  #
  # @see http://omdbapi.com
  class Client

    include HTTParty
    base_uri OMDB::Default::API_ENDPOINT

    # Retrieves a movie or show based on its title.
    #
    # @param title [String] The title of the movie or show.
    # @param options [Hash] Options for the title, plot or year.
    # @option options [Integer] :year The year of the movie.
    # @option options [String] :plot 'short' (default), 'full'
    # @return [Hash]
    # @example
    #   OMDB.title('Game of Thrones')
    def title(title, options={})
      params = build_params(title, options)
      get '/', params
    end


    # Retrieves a movie or show based on its IMDb ID.
    #
    # @param imdb_id [String] The IMDb ID of the movie or show.
    # @return [Hash]
    # @example
    #   OMDB.id('tt0944947')
    def id(imdb_id) 
      get '/', { i: imdb_id }
    end

    # Search for a movie by its title.
    #
    # @param title [String] The title of the movie or show to search for.
    # @return [Array, Hash]
    # @example
    #   OMDB.find('Star Wars')
    def search(title)
      results = get '/', { s: title }
      if results[:search]
        # Return the title if there is only one result, otherwise return the seach results
        search = results.search
        search.size == 1 ? title(search[0].title) : search
      else
        results
      end
    end

    alias_method :find, :search

    private

      # Performs a method on all hash keys.
      #
      # @param value [Array, Hash, Object]
      # @return [Array, Hash, Object]
      def convert_hash_keys(value)
        case value
        when Array
          value.map { |v| convert_hash_keys(v) }
        when Hash
          Hash[value.map { |k, v| [k.to_snake_case.to_sym, convert_hash_keys(v)] }]
        else
          value
        end
      end

      # Build parameters for a request.
      #
      # @param title [String] The title of the show.
      # @param options [Hash] The optional parameters.
      # @return [Hash]
      def build_params(title, options)
        params = { t: title }
        params[:plot] = options[:plot] if options[:plot]
        params[:y] = options[:year] if options[:year]
        params
      end

      # Performs a get request.
      #
      # @param url [String] The url to perform the get request to.
      # @param params [Hash] The parameters to pass in the query string.
      # @return [Hash] The response from the get request.
      # @example
      #   get '/users', { username: 'caseyscarborough' }
      def get(url, params={})
        request = self.class.get '/', query: params
        convert_hash_keys(request.parsed_response)
      end
  end
end