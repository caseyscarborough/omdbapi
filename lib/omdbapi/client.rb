module OMDB
  class Client

    include HTTParty
    base_uri OMDB::Default::API_ENDPOINT

    def title(title, year=nil)
      get '/', { t: title }
    end

    def id(imdb_id) 
      return get '/', { i: imdb_id }
    end

    def find(title)
      results = get '/', { s: title }
      results[:search] ? results[:search] : results
    end

    private

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

      def get(url, params={})
        request = self.class.get '/', query: params
        convert_hash_keys(JSON.parse(request.parsed_response))
      end
  end
end