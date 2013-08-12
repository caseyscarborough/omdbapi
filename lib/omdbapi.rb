require 'httparty'
require 'json'
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
      @client = Client.new unless @client
      @client
    end

    private

      def method_missing(name, *args, &block)
        client.send(name, *args, &block)
      end

  end
end
