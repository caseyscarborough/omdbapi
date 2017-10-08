module OMDB

  # Client for handling requests to the omdbapi.com API.
  #
  # @see http://omdbapi.com
  class Client

    include HTTParty
    base_uri OMDB::Default::API_ENDPOINT

    def initialize(api_key:)
      @api_key = api_key
    end

    # Retrieves a movie or show based on its title.
    #
    # @param title [String] The title of the movie or show.
    # @param options [Hash] Options for the title, plot or year.
    # @option options [Integer] :year The year of the movie.
    # @option options [String] :plot 'short' (default), 'full'
    # @option options [Integer] :season The season to retrieve.
    # @option options [Integer] :episode The episode to retrieve. Requires the season parameter.
    # @option options [Boolean] :tomatoes Include Rotten Tomatoes ratings.
    # @return [Hash]
    # @example
    #   OMDB.title('Game of Thrones')
    def title(title, options = {})
      options.merge!(title: title)
      params = build_params(options)
      get '/', params
    end

    # Retrieves a movie or show based on its IMDb ID.
    #
    # @param imdb_id [String] The IMDb ID of the movie or show.
    # @option options [Boolean] :tomatoes Include Rotten Tomatoes ratings.
    # @return [Hash]
    # @example
    #   OMDB.id('tt0944947')
    def id(imdb_id, options = {})
      options.merge!(id: imdb_id)
      params = build_params(options)
      get '/', params
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
      # @param options [Hash] The optional parameters.
      # @return [Hash]
      def build_params(options)
        params = {}
        params[:t] = options[:title] if options[:title]
        params[:i] = options[:id] if options[:id]
        params[:y] = options[:year] if options[:year]
        params[:plot] = options[:plot] if options[:plot]
        params[:season] = options[:season] if options[:season]
        params[:episode] = options[:episode] if options[:episode]
        params[:type] = options[:type] if options[:type]
        params[:tomatoes] = options[:tomatoes] if options[:tomatoes]
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
        request = self.class.get '/', query: params.merge(apikey: @api_key)
        convert_hash_keys(request.parsed_response)
      end
  end
end
