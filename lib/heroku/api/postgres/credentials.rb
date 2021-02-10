# frozen_string_literal: true

require 'net/http'
require 'json'
require 'platform-api'

module Heroku
  module Api
    module Postgres
      class Credentials
        def initialize(client)
          @client = client
        end

        # Public: Rotate the database credentials.
        #
        # @param app_id [String] the application name.
        # @param database_id [String] the database UUID.
        # @param name [String] the credential name to be rotated (default: `default`).
        def rotate(app_id, database_id, name: 'default')
          path = "/postgres/v0/databases/#{database_id}/credentials" \
                 "/#{URI.encode_www_form_component(name)}/credentials_rotation"
          @client.perform_post_request(path, {}, host: db_host(app_id, database_id))
        end

        private

        def db_host(app_id, database_id)
          @client.db_host(app_id, database_id)
        end
      end
    end
  end
end
