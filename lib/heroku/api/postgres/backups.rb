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

        def schedule(database_id)
          @client.perform_post_request("/client/v11/databases/#{database_id}/transfer-schedules",
                                       hour: 00,
                                       timezone: 'UTC',
                                       schedule_name: 'DATABASE_URL')
        end

        def capture(database_id)
          @client.perform_post_request("/client/v11/databases/#{database_id}/backups")
        end
      end
    end
  end
end
