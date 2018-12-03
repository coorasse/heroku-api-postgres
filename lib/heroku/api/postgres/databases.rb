require 'net/http'
require 'json'

module Heroku
  module Api
    module Postgres
      class Databases
        STARTER_HOST = 'https://postgres-starter-api.heroku.com'.freeze
        PRO_HOST = 'https://postgres-api.heroku.com'.freeze

        def initialize(client)
          @client = client
        end

        # original call returns simply a database object, therefore I call the info API.
        # perform_get_request "/client/v11/databases/#{database_id}/wait_status"
        def wait(database_id, options = { wait_interval: 3 })
          waiting = true
          while waiting do
            database = info(database_id)
            break unless database[:waiting?]
            sleep(options[:wait_interval])
          end
          database
        end

        def info(database_id)
          @client.perform_get_request("/client/v11/databases/#{database_id}")
        end

        def host_for(database)
          starter_plan?(database) ? STARTER_HOST : PRO_HOST
        end

        def starter_plan?(database)
          database['plan']['name'].match(/(dev|basic)$/)
        end
      end
    end
  end
end
