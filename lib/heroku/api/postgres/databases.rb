require 'net/http'
require 'json'

module Heroku
  module Api
    module Postgres
      class Databases
        def initialize(client)
          @client = client
        end

        def info(database_id)
          @client.perform_get_request("/client/v11/databases/#{database_id}")
        end
      end
    end
  end
end
