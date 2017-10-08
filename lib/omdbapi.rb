require 'httparty'
require 'omdbapi/version'
require 'omdbapi/default'
require 'omdbapi/client'

# Ruby wrapper for omdbapi.com API.
module OMDB

  class << self

    # API client for making calls to the omdbapi API.
    #
    # return [OMDB::Client] API Wrapper
    def client
      @client = Client.new(api_key: api_key) unless @client
      @client
    end

    # Return the API key or the ENV var OMDB_API_KEY to be used in all future
    # calls.
    #
    # return [String] API Key
    def api_key
      @api_key || ENV['OMDB_API_KEY']
    end

    # Set the API key to be used in all future calls.
    def api_key=(val)
      @api_key = val
    end

    private

      def method_missing(name, *args, &block)
        client.send(name, *args, &block)
      end

  end
end
