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
        def wait(app_id, database_id, options = { wait_interval: 3 })
          waiting = true
          while waiting
            database = info(app_id, database_id)
            break unless database[:waiting?]

            sleep(options[:wait_interval])
          end
          database
        end

        def info(app_id, database_id, options = { app_id: nil })
          @client.perform_get_request("/client/v11/databases/#{database_id}", host: host_for_app(app_id))
        end

        def host_for(database)
          starter_plan?(database) ? STARTER_HOST : PRO_HOST
        end

        def host_for_app(app_id)
          database = heroku_client.addon.list_by_app(app_id).find do |addon|
            addon['addon_service']['name'] == 'heroku-postgresql'
          end
          host_for(database)
        end

        def starter_plan?(database)
          database['plan']['name'].match(/(dev|basic)$/)
        end

        private

        def heroku_client
          @heroku_client ||= PlatformAPI.connect_oauth(@client.oauth_client_key)
        end
      end
    end
  end
end
