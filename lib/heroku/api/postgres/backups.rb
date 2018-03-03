require 'net/http'
require 'json'

module Heroku
  module Api
    module Postgres
      class Backups
        def initialize(client)
          @client = client
        end

        # backups:  from_type == 'pg_dump' && to_type == 'gof3r'
        # restores: from_type != 'pg_dump' && to_type == 'pg_restore'
        # copies:   from_type == 'pg_dump' && to_type == 'pg_restore'
        def list(app_id)
          @client.perform_get_request("/client/v11/apps/#{app_id}/transfers")
        end

        def schedules(database_id)
          @client.perform_get_request("/client/v11/databases/#{database_id}/transfer-schedules")
        end
      end
    end
  end
end
